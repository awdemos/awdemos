# TypeScript Demos

This directory contains self-contained TypeScript infrastructure-as-code (IaC) demos using [Pulumi](https://www.pulumi.com/).

## Demo Index

| Path | Cloud | Resource | Description |
|------|-------|----------|-------------|
| [`kubernetes/100_ways_to_deploy_kubernetes/aws_typescript/`](./kubernetes/100_ways_to_deploy_kubernetes/aws_typescript/) | AWS (EKS) | Kubernetes cluster | Creates an Amazon EKS cluster using the Pulumi EKS component. |
| [`kubernetes/100_ways_to_deploy_kubernetes/azure_typescript/`](./kubernetes/100_ways_to_deploy_kubernetes/azure_typescript/) | Azure (AKS) | Kubernetes cluster | Creates an Azure AKS managed cluster and exports an admin kubeconfig. |
| [`kubernetes/100_ways_to_deploy_kubernetes/gcp_typescript/`](./kubernetes/100_ways_to_deploy_kubernetes/gcp_typescript/) | GCP (GKE) | Kubernetes cluster | Creates a Google GKE cluster and exports the CA certificate. |
| [`pulumi-azure-tenant/`](./pulumi-azure-tenant/) | Azure | Azure AD B2C tenant | Provisions an Azure AD B2C tenant with configurable name and location. |

## Running the Demos

Each demo is an independent Pulumi project. From the demo directory:

```bash
npm install
pulumi stack init dev
pulumi config set <required-config> <value>
pulumi up
```

## Testing

Demos with TypeScript source include unit or smoke tests runnable via:

```bash
npm test
```
