# Screenshots & GIFs Guide

This document provides guidance for creating visual assets (screenshots and GIFs) for the demos in this portfolio. Visual proof of working projects significantly enhances credibility and demonstrates practical expertise.

---

## 📸 Screenshot & GIF Creation Guidelines

### Tools Recommended

**For Screenshots:**
- **macOS**: `screencapture` (built-in), `skitch`, `shottr`
- **Linux**: `scrot`, `flameshot`, `spectacle` (KDE)
- **Terminal**: `asciinema` (terminal recording), `ttygif` (GIF from terminal)

**For GIFs:**
- **macOS**: `LICEcap`, `CleanShot X`, `ScreenToGif` (via Wine)
- **Linux**: `byzanz`, `peek`, `kazam` (GIF output)
- **Terminal**: `ttyrec` + `ttygif`, `asciinema` + `asciicast2gif`

**For Screen Recording (MP4 then convert):**
- **OBS Studio**: Cross-platform, high quality
- **VLC Media Player**: Simple screen recording
- **macOS QuickTime**: Built-in screen recording

---

## 🎯 Demo-Specific Screenshots & GIFs

### AI/ML Infrastructure (`demos/llm/`)

#### 1. LLM Serving with NVIDIA GPUs

**Screenshot Required:**
- **Terminal**: Showing `nvidia-smi` output with GPU utilization
- **Terminal**: Inference request/response with timing metrics
- **Grafana Dashboard**: GPU metrics (utilization, memory, temperature)

**GIF Required:**
- **Terminal**: Running inference request showing real-time response
- **Grafana**: Animated metrics updating during load test

**Commands to Capture:**
```bash
# Show GPU utilization
nvidia-smi

# Run inference and capture timing
time curl -X POST http://localhost:8000/generate \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Explain quantum computing"}'
```

**Placement:**
- `/demos/llm/images/gpu-utilization.png`
- `/demos/llm/images/inference-response.png`
- `/demos/llm/images/grafana-gpu-metrics.gif`

---

#### 2. Multi-Agent AI Systems

**Screenshot Required:**
- **Terminal**: Multiple agents coordinating (showing log output)
- **Browser**: MCP client interface (Claude Desktop, Cursor)
- **Grafana**: Agent coordination metrics

**GIF Required:**
- **Terminal**: Agent task delegation and response flow
- **Browser**: Multi-agent conversation with user

**Placement:**
- `/demos/llm/images/multi-agent-terminal.png`
- `/demos/llm/images/mcp-client-interface.png`
- `/demos/llm/images/agent-coordination.gif`

---

### Kubernetes (`demos/kubernetes/`)

#### 3. Multi-Cloud Deployment

**Screenshot Required:**
- **Terminal**: `kubectl get nodes` showing multi-cluster output
- **Terminal**: `kubectl get pods --all-namespaces` across clusters
- **Grafana**: Multi-cluster dashboard with AWS, GCP, Azure

**GIF Required:**
- **Terminal**: Deploying application across all 3 clouds
- **Grafana**: Traffic routing across clusters (load balancing)

**Commands to Capture:**
```bash
# Show cluster context
kubectl config get-contexts

# Deploy across clusters
kubectl config use-context aws-eks
kubectl apply -f deployment.yaml

kubectl config use-context gcp-gke
kubectl apply -f deployment.yaml

kubectl config use-context azure-aks
kubectl apply -f deployment.yaml

# Show pods across all
kubectl get pods --all-namespaces -o wide
```

**Placement:**
- `/demos/kubernetes/images/multi-cluster-nodes.png`
- `/demos/kubernetes/images/deploy-across-clouds.gif`
- `/demos/kubernetes/images/grafana-multi-cluster.gif`

---

#### 4. GPU-Enabled Kubernetes

**Screenshot Required:**
- **Terminal**: `kubectl get nodes -o wide` showing GPU nodes
- **Terminal**: `kubectl describe node <gpu-node>` showing GPU resources
- **Dashboard**: NVIDIA GPU operator status

**GIF Required:**
- **Terminal**: Scheduling GPU workload (kubectl apply)
- **Dashboard**: GPU pods running and utilizing GPUs

**Commands to Capture:**
```bash
# Show GPU nodes
kubectl get nodes -l nvidia.com/gpu.present

# Show GPU resources on node
kubectl describe node gpu-node-1 | grep -A 10 "Allocated resources"

# Deploy GPU workload
kubectl apply -f gpu-workload.yaml
kubectl get pods -w
```

**Placement:**
- `/demos/kubernetes/images/gpu-nodes.png`
- `/demos/kubernetes/images/gpu-pod-scheduling.gif`
- `/demos/kubernetes/images/gpu-dashboard.png`

---

#### 5. Zero-Trust Networking with Cilium

**Screenshot Required:**
- **Terminal**: `cilium status` output
- **Terminal**: `cilium network policy list`
- **Hubble UI**: Network flow visualization

**GIF Required:**
- **Terminal**: Applying network policies
- **Hubble UI**: Network traffic flow between pods

**Commands to Capture:**
```bash
# Show Cilium status
cilium status

# List network policies
cilium network policy list

# Apply policy
cilium network policy create -f policy.yaml

# View flows with Hubble
cilium hubble observe --pod-labels app=frontend
```

**Placement:**
- `/demos/kubernetes/images/cilium-status.png`
- `/demos/kubernetes/images/hubble-network-flows.gif`
- `/demos/kubernetes/images/network-policy-apply.gif`

---

### Development Tools (`demos/rust/`, `demos/python/`)

#### 6. Rust CLI Performance Tool

**Screenshot Required:**
- **Terminal**: Help output (`cargo run -- --help`)
- **Terminal**: Performance comparison (before/after optimization)
- **Flamegraph**: CPU profile visualization

**GIF Required:**
- **Terminal**: Running tool with progress bars
- **Flamegraph**: Animated flamegraph generation

**Commands to Capture:**
```bash
# Build and run
cargo run --release -- --help

# Performance comparison
time cargo run --release -- benchmark --large-dataset

# Generate flamegraph
cargo flamegraph -- cargo run --release -- benchmark
```

**Placement:**
- `/demos/rust/images/cli-help.png`
- `/demos/rust/images/performance-comparison.png`
- `/demos/rust/images/flamegraph.svg`

---

#### 7. Python Best Practices

**Screenshot Required:**
- **IDE (VS Code)**: Project structure with type hints
- **Terminal**: `poetry install` and `poetry run pytest`
- **Terminal**: Coverage report output

**GIF Required:**
- **IDE**: Writing code with type checking in real-time
- **Terminal**: Running tests with colored output

**Commands to Capture:**
```bash
# Show project structure
tree -L 2

# Install dependencies
poetry install

# Run tests with coverage
poetry run pytest --cov=src --cov-report=term-missing

# Type checking
poetry run mypy src/
```

**Placement:**
- `/demos/python/images/project-structure.png`
- `/demos/python/images/tests-running.gif`
- `/demos/python/images/coverage-report.png`

---

### CI/CD (`demos/dagger-go-ci/`, `demos/pulumi-azure-tenant/`)

#### 8. Dagger Pipeline Execution

**Screenshot Required:**
- **Terminal**: Running Dagger pipeline locally
- **Terminal**: GitHub Actions workflow run output
- **Dashboard**: Pipeline execution visualization

**GIF Required:**
- **Terminal**: `dagger run` showing steps executing
- **GitHub Actions**: Workflow run progressing

**Commands to Capture:**
```bash
# Run pipeline locally
dagger run

# Show pipeline structure
dagger call

# Test specific step
dagger call test
```

**Placement:**
- `/demos/dagger-go-ci/images/pipeline-local-run.png`
- `/demos/dagger-go-ci/images/pipeline-execution.gif`
- `/demos/dagger-go-ci/images/github-actions-run.png`

---

#### 9. Pulumi Infrastructure Deployment

**Screenshot Required:**
- **Terminal**: `pulumi up` preview
- **Terminal**: Resource creation output
- **Azure Portal**: Deployed resources (virtual networks, AKS clusters)

**GIF Required:**
- **Terminal**: `pulumi up --yes` deploying resources
- **Azure Portal**: Resources appearing in real-time

**Commands to Capture:**
```bash
# Preview changes
pulumi preview

# Deploy infrastructure
pulumi up --yes

# Show resources
pulumi stack output
```

**Placement:**
- `/demos/pulumi-azure-tenant/images/pulumi-preview.png`
- `/demos/pulumi-azure-tenant/images/deployment.gif`
- `/demos/pulumi-azure-tenant/images/azure-resources.png`

---

## 🎨 Image Quality Guidelines

### Screenshots
- **Resolution**: Minimum 1920x1080 (Full HD)
- **Format**: PNG (lossless) for screenshots
- **File Size**: Keep under 500KB per image
- **Content**: Show full terminal window or relevant section
- **Annotations**: Add text overlays for key points (optional)

### GIFs
- **Resolution**: 1200x675 or higher (16:9 aspect ratio)
- **Frame Rate**: 10-15 fps (balance quality and file size)
- **Duration**: 5-15 seconds maximum
- **File Size**: Keep under 5MB per GIF
- **Content**: Show complete action start-to-finish
- **Optimization**: Use gifsicle or similar to optimize file size

### Terminal Screenshots
- **Font Size**: 14-16pt for readability
- **Theme**: Dark theme preferred (easier on eyes)
- **Window Size**: Full terminal width, show 20-30 lines
- **Prompt**: Clean prompt showing directory and user
- **Colors**: Enable colored output (`ls --color=auto`)

---

## 📁 Directory Structure

Create `images/` directories in each demo folder:

```
demos/
├── llm/
│   └── images/
│       ├── gpu-utilization.png
│       ├── inference-response.png
│       ├── grafana-gpu-metrics.gif
│       ├── multi-agent-terminal.png
│       └── mcp-client-interface.png
├── kubernetes/
│   └── images/
│       ├── multi-cluster-nodes.png
│       ├── deploy-across-clouds.gif
│       ├── gpu-nodes.png
│       └── cilium-status.png
├── rust/
│   └── images/
│       ├── cli-help.png
│       ├── performance-comparison.png
│       └── flamegraph.svg
├── python/
│   └── images/
│       ├── project-structure.png
│       ├── tests-running.gif
│       └── coverage-report.png
└── dagger-go-ci/
    └── images/
        ├── pipeline-local-run.png
        ├── pipeline-execution.gif
        └── github-actions-run.png
```

---

## 🔧 Quick Creation Commands

### macOS Terminal Screenshot
```bash
# Capture entire terminal window
screencapture -T 5 -x terminal.png

# Capture selection
screencapture -i selection.png
```

### Linux Terminal Screenshot
```bash
# Using scrot
scrot -s -d 5 terminal.png

# Using flameshot (interactive)
flameshot gui
```

### Terminal Recording to GIF
```bash
# Using ttyrec + ttygif
ttyrec session.tty
ttygif session.tty > session.gif

# Using asciinema + convert
asciinema rec session.cast
asciicast2gif session.cast session.gif
```

### OBS Studio Recording
1. Open OBS Studio
2. Add "Window Capture" or "Screen Capture" source
3. Set resolution to 1920x1080
4. Click "Start Recording"
5. Perform action
6. Stop recording
7. Convert MP4 to GIF:
   ```bash
   ffmpeg -i recording.mp4 -vf "fps=10,scale=1200:-1:flags=lanczos" -c:v gif recording.gif
   ```

---

## 📝 Documentation Updates

After creating screenshots/GIFs, update each demo's README.md to include them:

```markdown
## Screenshots

### GPU Utilization

![GPU Utilization](images/gpu-utilization.png)

### Inference Performance

![Inference Response](images/inference-response.png)

## Demos

### Multi-Agent Coordination

![Agent Coordination](images/agent-coordination.gif)
```

---

## ✅ Checklist

For each demo:
- [ ] Identify key features to showcase
- [ ] Create screenshots for static content
- [ ] Create GIFs for dynamic processes
- [ ] Optimize image file sizes
- [ ] Organize in `images/` directory
- [ ] Update README.md with image references
- [ ] Test image rendering in GitHub PR
- [ ] Add alt text for accessibility

---

## 📄 License

All screenshots and GIFs created for this portfolio are licensed under MIT License.

---

**Visual proof transforms claims into credibility. Screenshots show it works; GIFs show how it works.**
