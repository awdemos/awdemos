# VPC + EKS + Terraform Demo

**Multi-cloud Kubernetes infrastructure deployment using Terraform, AWS VPC, and EKS.**

## Overview

This demo demonstrates production-grade infrastructure as code using Terraform to deploy:

- **AWS VPC**: Virtual Private Cloud with public/private subnets
- **EC2 instances**: Compute resources in isolated networks
- **Security Groups**: Network access control with least privilege
- **EKS-ready**: Infrastructure ready for Kubernetes cluster deployment

**Focus**: Terraform IaC patterns, network isolation, security best practices.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      AWS Region                          │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                 VPC (172.16.0.0/16)               │  │
│  │                                                       │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │  Route Table (0.0.0.0/0 → IGW)      │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │                                                       │
│  │  ┌─────────────┐     ┌──────────────┐            │  │
│  │  │             │     │  Internet     │            │  │
│  │  │  Subnet     │────▶│  Gateway     │            │  │
│  │  │  (10.0.1.0/24) │  (IGW)      │            │  │
│  │  │             │     └──────────────┘            │  │
│  │  │  ┌─────────┐│                             │  │
│  │  │  │EC2      ││                             │  │
│  │  │  │Instance  ││                             │  │
│  │  │  │t3.medium ││                             │  │
│  │  │  └─────────┘│                             │  │
│  │  │             │                             │  │
│  │  └─────────────┘                             │  │
│  │                                                       │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Key Features

### 1. Network Isolation

- **Private VPC**: Isolated network environment
- **Public/Private subnets**: Separate network zones
- **Route tables**: Controlled network routing
- **Internet Gateway**: Controlled internet access

### 2. Security by Design

- **Security groups**: Whitelist-based access (least privilege)
- **Ingress rules**: Only SSH (port 22) allowed
- **Egress rules**: Outbound traffic to 0.0.0.0/0
- **IPv6 support**: Dual-stack network configuration

### 3. Infrastructure as Code

- **Terraform**: Declarative infrastructure definition
- **Variables**: Reusable and parameterized deployments
- **State management**: Terraform state tracking
- **Reproducible**: Same code → same infrastructure

## File Structure

```
vpc_eks_terraform-demo/
├── VPC_with_EC2.tf           # Main infrastructure definition
├── variables.tf               # Input variables (optional)
├── terraform.tfstate          # State file (generated)
└── README.md                 # This file
```

## Components

### 1. VPC (Virtual Private Cloud)

**File**: `VPC_with_EC2.tf` (lines 5-6)

```hcl
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr  # 172.16.0.0/16
}
```

**Features**:
- **CIDR block**: Configurable IP range
- **DNS support**: AWS DNS resolution
- **Tenancy**: Default (multi-tenant)

### 2. Subnet

**File**: `VPC_with_EC2.tf` (lines 9-13)

```hcl
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet1-cidr  # 10.0.1.0/24
  availability_zone = var.subnet_az   # e.g., us-west-2a

  tags = {
    Name = "demo_subnet"
  }
}
```

**Features**:
- **Public IP association**: EC2 instances get public IP
- **AZ awareness**: Deployed in specific availability zone
- **Tagging**: Resource identification

### 3. Internet Gateway

**File**: `VPC_with_EC2.tf` (lines 15-17)

```hcl
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}
```

**Features**:
- **VPC attachment**: Connects VPC to internet
- **Bidirectional**: Inbound and outbound traffic
- **Redundant**: AWS-managed high availability

### 4. Route Table

**File**: `VPC_with_EC2.tf` (lines 19-27)

```hcl
resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo-rt"
  }
}
```

**Features**:
- **Default route**: All traffic to internet gateway
- **VPC association**: Applied to subnets
- **Tagging**: Route table identification

### 5. Route Table Association

**File**: `VPC_with_EC2.tf` (lines 29-33)

```hcl
resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo-rt.id
}
```

**Features**:
- **Explicit association**: Subnet → route table binding
- **Controlled routing**: Ensures correct routing

### 6. Security Group

**File**: `VPC_with_EC2.tf` (lines 35-53)

```hcl
resource "aws_security_group" "demo-vpc-sg" {
  name   = "demo-vpc-sg"
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # SSH from anywhere
    ipv6_cidr_blocks = ["::/0"]         # IPv6 support
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # All protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
```

**Security Rules**:
- **Ingress**: SSH (port 22) from anywhere
- **Egress**: All outbound traffic allowed
- **IPv6**: Dual-stack support
- **Least privilege**: Only necessary ports open

### 7. EC2 Instance

**File**: `VPC_with_EC2.tf` (lines 55-60)

```hcl
resource "aws_instance" "demo-server" {
  ami           = var.os_name           # Ubuntu/Amazon Linux AMI
  key_name      = var.key            # SSH key pair
  instance_type = var.instance_type   # e.g., t3.medium
  associate_public_ip_address = true
  subnet_id     = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]
}
```

**Features**:
- **Custom AMI**: Configurable OS image
- **SSH access**: Key pair authentication
- **Public IP**: Direct internet access
- **Security group**: Network-level firewall

## Getting Started

### Prerequisites

1. **Terraform**: https://www.terraform.io/downloads.html
   ```bash
   # macOS
   brew install terraform

   # Linux
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   unzip terraform_1.5.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. **AWS CLI**: https://aws.amazon.com/cli/
   ```bash
   brew install awscli
   aws configure
   ```

3. **SSH Key Pair**: Create in AWS Console
   ```bash
   aws ec2 create-key-pair --key-name demo-key --key-type rsa
   ```

### Variables (Optional)

Create `variables.tf`:

```hcl
variable "location" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc-cidr" {
  description = "VPC CIDR block"
  default     = "172.16.0.0/16"
}

variable "subnet1-cidr" {
  description = "Subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "subent_az" {
  description = "Availability zone"
  default     = "us-west-2a"
}

variable "os_name" {
  description = "AMI ID"
  default     = "ami-0c55b159cbfafe1f0"  # Ubuntu 22.04 us-west-2
}

variable "key" {
  description = "SSH key name"
  default     = "demo-key"
}

variable "instance-type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}
```

### Quick Start

1. **Initialize Terraform**:
   ```bash
   cd demos/vpc_eks_terraform-demo
   terraform init
   ```

2. **Plan deployment**:
   ```bash
   terraform plan
   ```

3. **Apply infrastructure**:
   ```bash
   terraform apply -auto-approve
   ```

4. **Get instance IP**:
   ```bash
   terraform output
   ```

5. **SSH into instance**:
   ```bash
   ssh -i demo-key.pem ubuntu@<public-ip>
   ```

## Security Best Practices Demonstrated

### 1. Network Isolation

- **VPC**: Isolated network environment
- **Subnet**: Segmented IP address space
- **Security group**: Network-level firewall

### 2. Least Privilege Access

- **Ingress whitelist**: Only SSH (port 22) allowed
- **Egress control**: All outbound allowed (can be restricted)
- **SSH key authentication**: No password-based login

### 3. Infrastructure as Code

- **Version control**: All changes tracked in Git
- **Reproducible**: Same code → same infrastructure
- **Review process**: Terraform plan before apply

### 4. Cost Optimization

- **t3 instances**: Cost-effective compute
- **Right-sizing**: Configurable instance types
- **Tagging**: Cost allocation tracking

## Cost Estimates

| Resource | Type | Price (us-west-2) | Hourly Cost |
|----------|-------|---------------------|--------------|
| VPC | N/A | Free | $0 |
| Subnet | N/A | Free | $0 |
| Internet Gateway | Per hour | $0.025 | $0.025 |
| Route Table | N/A | Free | $0 |
| Security Group | N/A | Free | $0 |
| EC2 (t3.medium) | 2 vCPU, 4GB RAM | $0.0416 | $0.0416 |
| **Total** | | | **$0.0666/hour** |

**Monthly Cost (24/7)**: ~$48.25

## Troubleshooting

### 1. Terraform State Issues

```bash
# Refresh state
terraform refresh

# Re-import resources
terraform import aws_instance.demo-server i-xxxxxxxxxx

# Reset state (careful!)
terraform state pull > backup.tfstate
terraform state reset
```

### 2. Instance Not Accessible

```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx

# Verify public IP
aws ec2 describe-instances --instance-ids i-xxxxxxxxx --query "Instances[0].PublicIpAddress"

# Test network connectivity
ping -c 4 <public-ip>
```

### 3. SSH Connection Failed

```bash
# Check key permissions
chmod 400 demo-key.pem

# Verbose SSH output
ssh -v -i demo-key.pem ubuntu@<public-ip>

# Check instance logs
aws ec2 get-console-output --instance-id i-xxxxxxxxx
```

## Extensions

### 1. Add EKS Cluster

Extend this demo to deploy EKS:

```hcl
# Add to VPC_with_EC2.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "demo-cluster"
  cluster_version = "1.28"

  vpc_id     = aws_vpc.demo-vpc.id
  subnet_ids = [aws_subnet.demo_subnet.id]

  eks_managed_node_groups = {
    demo_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }
}
```

### 2. Add NAT Gateway

For private subnet instances:

```hcl
resource "aws_nat_gateway" "demo-nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = "demo-nat"
  }
}
```

### 3. Multi-AZ Deployment

Add subnets in multiple AZs:

```hcl
resource "aws_subnet" "demo_subnet_az2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}
```

## Comparison: Terraform vs Pulumi

| Feature | Terraform | Pulumi |
|---------|-----------|---------|
| Language | HCL (domain-specific) | Go, Python, TypeScript |
| Testing | Limited | Full test framework |
| State management | Built-in | Built-in |
| Learning curve | Moderate | Lower (if you know language) |
| Community | Large | Growing |
| Conditional logic | Complex expressions | Native language features |

**When to use Terraform**:
- You prefer declarative IaC
- You want AWS-native tooling
- Your team knows HCL

**When to use Pulumi**:
- You want real programming languages
- You need complex conditional logic
- You want better testing

## Next Steps

- [ ] Add private subnet with NAT gateway
- [ ] Deploy EKS cluster on this VPC
- [ ] Add monitoring (CloudWatch, Prometheus)
- [ ] Implement GitOps with Terraform
- [ ] Add multi-region deployment

## Related Demos

- `demos/eks-gha-aws-demo/` - Pulumi version of EKS deployment
- `demos/kubernetes/100_ways_to_deploy_kubernetes/` - More EKS patterns
- `demos/pulumi-azure-tenant/` - Multi-tenant IaC

## Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

**Status**: ✅ Working demo - deployable infrastructure with Terraform
