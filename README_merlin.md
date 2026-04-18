<div align="center">

# 🧙‍♂️ Merlin

### Intelligent Multi-Provider LLM Router

[![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)
[![Tokio](https://img.shields.io/badge/Tokio-000000?style=for-the-badge&logo=rust&logoColor=white)]()

**Sub-millisecond LLM prompt routing using reinforcement learning.**  
Route every prompt to the optimal model based on latency, cost, and quality — with zero GC pauses.

Built for [RegicideOS](https://github.com/awdemos/RegicideOS) and production AI infrastructure.

[⚡ Quick Start](#quick-start) · [🧠 Routing Algorithms](#routing-algorithms) · [📊 Observability](#observability) · [🚀 Deployment](#deployment)

</div>

---

## 🎯 What Merlin Does

Merlin sits between your application and multiple LLM providers. Instead of hard-coding a model choice, you send a prompt to Merlin and it **intelligently selects the best provider in real time** based on:

- ⚡ **Latency** — Route to the fastest available endpoint
- 💰 **Cost** — Prefer cheaper models for low-stakes queries
- 🎯 **Quality** — Use premium models when accuracy matters
- 📈 **Load** — Balance traffic across healthy providers

All routing decisions happen in **under a millisecond** thanks to Rust + Tokio async.

---

## ✨ Features

| Feature | Detail |
|---------|--------|
| 🔌 **Multi-Provider** | OpenAI, Anthropic, Gemini, local GGUF models — all via a single endpoint |
| 🧠 **Smart Routing** | Epsilon-greedy and Thompson sampling bandit algorithms |
| 📊 **Real-Time Metrics** | Latency, cost, and quality tracking per provider |
| 🏆 **Quality Judging** | On-device GPT-2 reward model for response scoring |
| 📈 **Observability** | Prometheus metrics, Jaeger tracing, Grafana dashboards |
| 🦀 **Zero GC Pauses** | Rust + Tokio async for predictable, sub-ms routing |
| 🔒 **Security Hardened** | Systemd service with non-root execution, memory limits, auto-restart |

---

## ⚡ Quick Start

```bash
# Clone
git clone https://github.com/awdemos/merlin.git
cd merlin

# Build
cargo build --release

# Configure
cat > merlin.toml << 'EOF'
[providers]
openai = { api_key = "sk-...", model = "gpt-4-turbo" }
anthropic = { api_key = "sk-ant-...", model = "claude-3-opus" }

[routing]
policy = "thompson_sampling"
exploration_rate = 0.15

[telemetry]
prometheus_port = 9090
EOF

# Run
./target/release/merlin serve --port 7777 --config ./merlin.toml
```

---

## 🧠 Routing Algorithms

Merlin implements two multi-armed bandit strategies for provider selection:

### Epsilon-Greedy
Explores random providers with probability ε, otherwise exploits the current best.

```toml
[routing]
policy = "epsilon_greedy"
exploration_rate = 0.10  # 10% exploration
```

### Thompson Sampling
Bayesian approach that naturally balances exploration and exploitation based on observed reward distributions.

```toml
[routing]
policy = "thompson_sampling"
```

### Reward Function
Merlin scores each response using a composite reward:

```
reward = α·(1/latency) + β·(1/cost) + γ·quality_score
```

Where `quality_score` comes from either:
- User feedback (explicit thumbs up/down)
- On-device GPT-2 reward model (automatic)
- Task-specific heuristics

---

## 📡 API

### Chat Endpoint

```bash
curl -X POST http://localhost:7777/chat \
  -H "Content-Type: application/json" \
  -d '{"prompt": "What is the capital of France?", "max_tokens": 100}'
```

```json
{
  "response": "The capital of France is Paris.",
  "provider": "openai",
  "latency_ms": 245,
  "cost_estimate": 0.002
}
```

### Health & Metrics

```bash
curl http://localhost:7777/health
curl http://localhost:7777/metrics
```

---

## 📊 Observability

Merlin exports Prometheus-compatible metrics and Jaeger traces out of the box:

| Metric | Description |
|--------|-------------|
| `merlin_requests_total` | Total requests routed |
| `merlin_latency_ms` | p50/p95/p99 latency per provider |
| `merlin_cost_usd` | Estimated cost per provider |
| `merlin_reward_score` | Average reward per provider |

**Grafana dashboard included** in `dashboards/`.

---

## 🚀 Deployment

### Systemd Service (Production)

```bash
# Build and install
cargo build --release
sudo ./scripts/install-systemd.sh

# Manage
sudo systemctl enable --now merlin
sudo systemctl status merlin
journalctl -u merlin -f
```

Service features:
- 🔒 Non-root execution with restricted permissions
- 📊 Memory limits and CPU scheduling
- 🔄 Auto-restart on failure
- 📝 Native journald logging

### Configuration Files

| File | Purpose |
|------|---------|
| `/etc/merlin/merlin.toml` | Main configuration |
| `/etc/merlin/merlin.env` | Environment variables |
| `/etc/systemd/system/merlin.service` | Service definition |

---

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────▶│   Merlin    │────▶│  Provider   │
│  (Your App) │◀────│   Router    │◀────│   (LLM)     │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌─────────┐  ┌─────────┐  ┌─────────┐
        │ Metrics │  │  Traces │  │  Cache  │
        │(Prom)   │  │(Jaeger) │  │ (Redis) │
        └─────────┘  └─────────┘  └─────────┘
```

---

## 🗺️ Roadmap

- [x] Multi-provider routing
- [x] Epsilon-greedy & Thompson sampling
- [x] Prometheus metrics
- [x] Systemd service deployment
- [ ] TensorRT-LLM backend for local GPU inference
- [ ] Dynamic model warm/cold pool management
- [ ] Distributed routing cluster (Raft consensus)
- [ ] Automatic fallback chaining with circuit breakers

---

## 🤝 Contributing

Contributions welcome! Areas of interest:

- Additional routing algorithms (UCB, EXP3)
- New provider backends (Azure OpenAI, Bedrock, Vertex)
- Performance benchmarks and profiling
- Grafana dashboard improvements

---

<div align="center">

**© 2026 Andrew White · RegicideOS Project · GPL v3**

</div>
