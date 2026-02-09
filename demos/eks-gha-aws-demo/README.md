# EKS + GitHub Actions Demo

**Automated Kubernetes infrastructure deployment with Pulumi, GitHub Actions, and AWS.**

## Overview

This demo showcases production-grade infrastructure as code using:

- **Pulumi (Go)**: Infrastructure as code with general-purpose programming language
- **AWS EKS**: Elastic Kubernetes Service for managed Kubernetes
- **GitHub Actions**: CI/CD pipeline for automated deployment
- **Private Subnet Nodes**: Secure worker nodes in private subnets

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Actions CI/CD                    │
│  (push → build → test → pulumi up)                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                      AWS Region                          │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    VPC (172.16.0.0/16)          │  │
│  │                                                       │
│  │  ┌─────────────┐      ┌─────────────┐            │  │
│  │  │  Public     │      │  Private    │            │  │
│  │  │  Subnet     │      │  Subnet     │            │  │
│  │  │  (10.0.1.0) │      │  (10.0.2.0) │            │  │
│  │  │             │      │             │            │  │
│  │  │  EKS Control│      │  Worker     │            │  │
│  │  │  Plane (2x   │      │  Nodes (t3) │            │  │
│  │  │  t3.medium)  │◄─────┤  4 nodes    │            │  │
│  │  └─────────────┘      └─────────────┘            │  │
│  │        │                      │                     │  │
│  │        ▼                      ▼                     │  │
│  │  ┌─────────────┐      ┌─────────────┐            │  │
│  │  │  Internet   │      │  Internal   │            │  │
│  │  │  Gateway   │      │  LB / API   │            │  │
│  │  └─────────────┘      └─────────────┘            │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Key Features

### Infrastructure as Code (Pulumi Go)

```go
// VPC with public/private subnets
vpc, err := ec2.NewVpc(ctx, "vpc", &ec2.VpcArgs{
    CidrBlock: &cidrBlock,
    SubnetSpecs: []ec2.SubnetSpecArgs{
        {Type: ec2.SubnetTypePublic},
        {Type: ec2.SubnetTypePrivate},
    },
})

// EKS cluster with private worker nodes
cluster, err := lbrlabs.NewCluster(ctx, "cluster", &lbrlabs.ClusterArgs{
    ClusterSubnetIds:    vpc.PublicSubnetIds,
    SystemNodeSubnetIds: vpc.PrivateSubnetIds,
    SystemNodeInstanceTypes: pulumi.StringArray{
        pulumi.String("t3.medium"),
    },
    SystemNodeDesiredCount: pulumi.Float64Ptr(4),
})
```

### Security

- **Private subnet workers**: No direct internet access from control plane
- **Network isolation**: Separate public and private subnets
- **Least privilege**: IAM roles scoped to EKS operations
- **Let's Encrypt**: Automatic SSL certificate provisioning

### Scalability

- **Auto-scaling**: Node groups scale based on demand
- **Multiple instance types**: t3.medium for system nodes, configurable for workers
- **Horizontal scaling**: Add/remove worker nodes via Pulumi

## Getting Started

### Prerequisites

1. **AWS Account**: Configure AWS credentials
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_REGION="us-west-2"
   ```

2. **Install Pulumi**: https://www.pulumi.com/docs/get-started/install/
   ```bash
   # macOS
   brew install pulumi

   # Linux
   curl -fsSL https://get.pulumi.com | sh
   ```

3. **Install Go**: https://golang.org/doc/install
   ```bash
   brew install go
   ```

4. **Install dependencies**:
   ```bash
   cd demos/eks-gha-aws-demo
   go mod download
   ```

### Quick Start

1. **Create Pulumi stack**:
   ```bash
   pulumi stack init eks-demo
   pulumi config set aws:region us-west-2
   ```

2. **Deploy infrastructure**:
   ```bash
   pulumi up
   ```

3. **Access cluster**:
   ```bash
   pulumi stack output kubeconfig > kubeconfig.yaml
   export KUBECONFIG=$(pwd)/kubeconfig.yaml
   kubectl get nodes
   ```

### GitHub Actions Integration

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy EKS Cluster

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: Install Pulumi
        run: curl -fsSL https://get.pulumi.com | sh

      - name: Configure AWS
        run: |
          echo "AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}" >> $GITHUB_ENV
          echo "AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}" >> $GITHUB_ENV

      - name: Deploy to EKS
        run: |
          pulumi login
          pulumi stack init
          pulumi up --yes
```

## File Structure

```
eks-gha-aws-demo/
├── main.go              # Pulumi infrastructure definition
├── go.mod               # Go module dependencies
├── go.sum               # Dependency checksums
├── Pulumi.yaml           # Pulumi project config
└── README.md            # This file
```

## Key Components

### 1. VPC and Networking

**File**: `main.go` (lines 18-32)

- **Public subnets**: EKS control plane, load balancers
- **Private subnets**: Worker nodes, no direct internet access
- **Internet gateway**: Public subnet connectivity
- **Route tables**: Network routing between subnets

### 2. EKS Control Plane

**File**: `main.go` (lines 34-45)

- **EKS API server**: Managed by AWS
- **System nodes**: 2x t3.medium in private subnets
- **Auto-scaling**: Desired count 4, configured for scaling
- **Let's Encrypt**: Automatic SSL certificate for API endpoint

### 3. Worker Nodes

**File**: `main.go` (lines 47-56)

- **Attached node group**: Separate from system nodes
- **Private subnets**: Worker nodes in isolated network
- **Scalable**: Configurable min/max node counts
- **t3 instances**: Cost-effective compute for Kubernetes

### 4. Workloads

**File**: `main.go` (lines 58-70)

- **Namespace**: Isolated application deployment
- **Deployment**: Sample application for testing
- **Service**: Exposes application via load balancer

## Best Practices Demonstrated

### 1. Infrastructure as Code

- **Go language**: Type safety, testing, IDE support
- **Pulumi**: Real programming language, not HCL
- **Version control**: All infrastructure in Git
- **Reproducible**: Same inputs → same infrastructure

### 2. Security

- **Private subnets**: Worker nodes isolated from public internet
- **IAM roles**: Scoped to minimum required permissions
- **Network isolation**: Public/private subnet separation
- **SSL certificates**: Automatic HTTPS via Let's Encrypt

### 3. Scalability

- **Auto-scaling**: Nodes scale based on workload
- **Cost optimization**: t3 instances for cost efficiency
- **Multi-AZ**: Deployed across availability zones
- **Horizontal scaling**: Add/remove nodes dynamically

### 4. GitOps

- **GitHub Actions**: Automated deployment on push
- **Infrastructure versioning**: Changes tracked in Git
- **Rollback**: `pulumi down` to destroy, `pulumi up` to redeploy
- **Environment parity**: Same pipeline for dev/staging/prod

## Cost Estimates

| Resource | Quantity | Price (us-west-2) | Monthly Cost |
|----------|-----------|---------------------|--------------|
| EKS Control Plane | 1 cluster | $73/month | $73 |
| t3.medium (system nodes) | 2 nodes | $0.0416/hr | $60.12 |
| t3.medium (worker nodes) | 4 nodes | $0.0416/hr | $120.24 |
| Load Balancer | 1 ALB | $0.025/hr + LCU | ~$40 |
| NAT Gateway | 1 gateway | $0.045/hr + $0.045/GB | ~$60 |
| **Total** | | | **~$353/month** |

*Estimates based on 24/7 uptime. Costs vary by usage and region.*

## Troubleshooting

### 1. Pulumi Stack Issues

```bash
# View stack state
pulumi stack output

# Reset failed deployment
pulumi refresh
pulumi up
```

### 2. Cluster Not Ready

```bash
# Check node status
kubectl get nodes

# Check pod status
kubectl get pods -A

# View events
kubectl get events --sort-by='.lastTimestamp'
```

### 3. Network Connectivity

```bash
# Test private subnet connectivity
kubectl run test-pod --image=busybox --rm -it -- sh
ping google.com  # Should work via NAT gateway
```

## Next Steps

- [ ] Add monitoring stack (Prometheus, Grafana)
- [ ] Implement GitOps with Argo CD
- [ ] Add secrets management (External Secrets Operator)
- [ ] Configure Cilium networking
- [ ] Add GPU node group for AI/ML workloads

## Related Demos

- `demos/kubernetes/100_ways_to_deploy_kubernetes/` - More EKS deployment patterns
- `demos/pulumi-azure-tenant/` - Pulumi multi-tenant architecture
- `demos/vpc_eks_terraform-demo/` - Terraform version of VPC+EKS

## Resources

- [Pulumi Go SDK](https://www.pulumi.com/docs/reference/pkg/go/)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [lbrlabs EKS Provider](https://github.com/lbrlabs/pulumi-lbrlabs-eks)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Status**: ✅ Working demo - deployable infrastructure with Pulumi and GitHub Actions
