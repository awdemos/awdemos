use anyhow::{Context, Result};
use axum::{
    extract::{Json, State},
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use candle::{Device, Tensor};
use candle_transformers::models::quantized_llama::{ModelWeights, QLlama};
use candle_nn::VarBuilder;
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::RwLock;
use tracing::{error, info};

/// Zero-copy inference state
struct InferenceState {
    model: Option<QLlama>,
    device: Device,
    active_requests: Arc<RwLock<usize>>,
}

#[derive(Debug, Serialize)]
struct HealthStatus {
    status: String,
    model_loaded: bool,
    gpu_available: bool,
    active_requests: usize,
}

#[derive(Debug, Deserialize)]
struct CompletionRequest {
    model: String,
    prompt: String,
    #[serde(default = "512")]
    max_tokens: u32,
    #[serde(default = "0.7")]
    temperature: f32,
    #[serde(default = "false")]
    stream: bool,
}

#[derive(Debug, Serialize)]
struct CompletionResponse {
    text: String,
    model: String,
    tokens_used: u32,
    finish_reason: String,
}

#[derive(Debug, Serialize)]
struct ErrorResponse {
    error: String,
    detail: String,
}

impl InferenceState {
    fn new(device: Device) -> Self {
        Self {
            model: None,
            device,
            active_requests: Arc::new(RwLock::new(0)),
        }
    }

    fn load_model(&mut self, model_path: &str) -> Result<()> {
        info!("Loading model from: {}", model_path);
        
        let model_weights = ModelWeights::from_file(model_path)
            .with_context(|| format!("Failed to load model from {}", model_path))?;
        
        let device = &self.device;
        let config = candle_transformers::models::quantized_llama::Config::from_hf(model_path)?;
        
        let vb = VarBuilder::new();
        let model = QLlama::load(&model_weights, &config, &vb, device)
            .with_context(|| "Failed to load QLlama model")?;
        
        self.model = Some(model);
        info!("Model loaded successfully");
        Ok(())
    }

    async fn increment_requests(&self) {
        let mut count = self.active_requests.write().await;
        *count += 1;
    }

    async fn decrement_requests(&self) {
        let mut count = self.active_requests.write().await;
        *count = count.saturating_sub(1);
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt()
        .with_env_filter("llm_inference_server=info")
        .init();

    info!("Starting LLM Inference Server");

    // Initialize CUDA device
    let device = Device::cuda_if_available(0)
        .with_context(|| "CUDA device not available")?;
    
    info!("Using device: {:?}", device);

    // Initialize inference state
    let state = Arc::new(RwLock::new(InferenceState::new(device)));

    // Build router
    let app = Router::new()
        .route("/health", get(health_check))
        .route("/v1/completions", post(completions));

    // Start server
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000")
        .await
        .with_context(|| "Failed to bind to port 8000")?;
    
    info!("Server listening on http://0.0.0.0:8000");
    axum::serve(listener, app).await?;

    Ok(())
}

/// Health check endpoint
async fn health_check(State(state): State<Arc<RwLock<InferenceState>>>) -> Json<HealthStatus> {
    let state = state.read().await;
    
    Json(HealthStatus {
        status: "healthy".to_string(),
        model_loaded: state.model.is_some(),
        gpu_available: matches!(state.device, Device::Cuda(_)),
        active_requests: *state.active_requests.read().await,
    })
}

/// Completions endpoint
async fn completions(
    State(state): State<Arc<RwLock<InferenceState>>>,
    Json(req): Json<CompletionRequest>,
) -> Result<Json<CompletionResponse>, (StatusCode, Json<ErrorResponse>)> {
    let mut state = state.write().await;
    
    // Load model if not loaded
    if state.model.is_none() {
        if let Err(e) = state.load_model(&req.model) {
            return Err((
                StatusCode::INTERNAL_SERVER_ERROR,
                Json(ErrorResponse {
                    error: "model_load_failed".to_string(),
                    detail: e.to_string(),
                }),
            ));
        }
    }

    // Increment active requests
    state.increment_requests().await;
    
    // Get model reference
    let model = state.model.as_ref().unwrap();
    
    info!("Processing completion request: {} tokens", req.max_tokens);
    
    // Zero-copy inference (simplified for demo)
    let response_text = format!(
        "AI inference response for: {}",
        req.prompt.trim()
    );
    
    let tokens_used = req.prompt.split_whitespace().count() as u32;
    
    // Decrement active requests
    state.decrement_requests().await;
    
    Ok(Json(CompletionResponse {
        text: response_text,
        model: req.model,
        tokens_used,
        finish_reason: "length".to_string(),
    }))
}
