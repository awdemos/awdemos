# demos/kubernetes — KNOWLEDGE BASE

## OVERVIEW

Production Kubernetes deployment patterns across AWS, GCP, and Azure. Includes Cilium eBPF networking, multi-cluster federation, deterministic builds, and 100+ reference implementations.

## STRUCTURE

```
kubernetes/
├── 100_ways_to_deploy_kubernetes/  # Same pattern x15 (5 langs x 3 clouds)
├── argo/                           # Argo Workflows/CD examples
├── cilium*                         # eBPF networking scripts
├── eks_node_aws_pulumi/            # EKS node provisioning
├── pod_performance_tests/          # Benchmarking manifests
├── talos/                          # Immutable K8s OS patterns
├── *.md                            # Deep-dive guides
└── *.yaml                          # Raw manifests
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Cloud-specific deployments | `100_ways_to_deploy_kubernetes/<cloud>_<lang>/` | AWS/GCP/Azure in Go/TS/Python/C#/YAML |
| Cilium eBPF setup | `cilium_install.sh`, `cilium/` | Kernel-bypass networking |
| Deterministic builds | `Deterministic_builds.md` | Reproducible container strategies |
| Pod lifecycle deep-dive | `How_pod_gets_deployed.md` | Step-by-step scheduling walkthrough |
| etcd inspection | `Inspect_etcd.md` | Troubleshooting cluster state |
| Multi-cluster patterns | `MultiCluster.md` | Federation and workload distribution |
| Argo CD/Workflows | `argo/` | GitOps manifests |

## CONVENTIONS

- **Declarative manifests** — raw YAML over Helm unless complexity demands it
- **Cloud-agnostic patterns** — same architecture repeated per cloud to show provider differences
- **eBPF-first networking** — Cilium preferred over Calico/Flannel

## ANTI-PATTERNS

- Do NOT treat `100_ways_to_deploy_kubernetes/` as DRY — it is intentionally repetitive for pedagogy
- Avoid provider-specific CRDs in shared patterns
