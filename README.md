# README

## Project Overview

This repository showcases a collection of demo projects that demonstrate the setup of various services in AWS and GCP, leveraging modern infrastructure as code practices for Kubernetes, containers, and other projects I find interesting. It includes examples using Pulumi for deploying resources, containerization with containerd and Kubernetes for orchestration as well as some nice to haves like git tips, zsh and neovim configs, and a lot more.

Be sure to check out the Ultimate Kubernetes Wishlist and Inspecting Images documentation. (I will get around to automating this eventually)

### Highlights:

- **Pulumi Projects**: Utilizes Pulumi for infrastructure as code to deploy resources into AWS, with configurations written in Go. For more information, please see [Pulumi's Go documentation](https://www.pulumi.com/docs/languages-sdks/go/).

- **Ethereum Node Deployment**: Features an infrastructure setup including a VPC, public subnet, internet gateway, route table, security group, and an EC2 instance. The EC2 instance is configured to install and run an Ethereum node using the `geth` command.

- **Fargate Integration**: Demonstrates building a local Docker container and pushing it to an AWS ECR repository, presumably for later ingestion into Kubernetes.

- **Kubernetes Deployments**: Includes examples of Kubernetes deployments, showcasing how to orchestrate containerized applications across a cluster of machines.

## Prerequisites

- Terraform
- Pulumi
- AWS/GCP CLI configured with your credentials
- Docker
- Containerd
- Kubernetes CLI (kubectl)

## Setup Instructions

### Cloning the Repository

```bash
git clone https://github.com/awdemos/demos.git
cd demos
```

The terraform-ethereum-aws project is deliberetly naive in the interest of time. 

2. Initialize Terraform:

```bash
terraform init
```

3. Review the plan:

```bash
terraform plan
```

4. Apply the changes:

```bash
terraform apply
```

## Pulumi

To stand up Pulumi for the other projects, you need to follow these steps:

1. **Install Pulumi**: If you haven't installed Pulumi yet, you can do so by running the following command:

```bash
curl -fsSL https://get.pulumi.com | sh
```

2. **Configure AWS**: Pulumi uses AWS credentials to deploy and manage resources, so you need to configure your AWS credentials. You can do this by running:

```bash
pulumi config set aws:region <region> # replace <region> with your AWS region, e.g., us-west-2
```

3. **Initialize a New Pulumi Project**: Navigate to the directory of the project you want to stand up and initialize a new Pulumi project:

```bash
cd <project-directory> # replace <project-directory> with the directory of your project
pulumi new go
```

Note you may need to install additional go libraries such as 

```bash
go get github.com/pulumi/pulumi-awsx/sdk/go/awsx/ecs
```

4. **Deploy the Pulumi Project**: Now you can deploy your Pulumi project by running:

```bash
pulumi up
```

This command will preview the changes to be made and, after confirmation, apply those changes.

For each project, you need to navigate to the project's directory and run the `pulumi up` command.

Please note that you need to replace `<project-directory>` with the actual directory of your project. Also, make sure to replace `<region>` with your AWS region, e.g., `us-west-2`.

For the Ethereum node project on GCP, you need to configure GCP instead of AWS:

```bash
gcloud auth application-default login
gcloud config set project ethereum-node-demo
pulumi config set gcp:project <project> # replace <project> with your GCP project ID
```

And initialize a new Pulumi project with the GCP Go template:

```bash
pulumi new gcp-go
```

Then you can deploy the project as usual with `pulumi up

## Configuration

The following variables can be configured in `main.tf`:

- `region`: AWS region to deploy the resources (default: `us-west-2`)
- `cidr_block`: CIDR block for the VPC (default: `10.0.0.0/16`)
- `ami`: AMI ID for the EC2 instance (default: `ami-0a62a741df1d21fab`)
- `instance_type`: Instance type for the EC2 instance (default: `m5.large`)
- `volume_size`: Root volume size in GB (default: `2500`)
- `key_name`: Name of the key pair for SSH access (default: `your_keypair`)

## Security

The security group is configured to allow all inbound traffic on ports 30303 and 8545 from any IP address. Consider restricting the IP addresses that can access your node.

## User Data Script

The user data script is installing Ethereum and starting the `geth` command. Make sure the `geth` command options are suitable for your needs.

## Contributing

While this is my demo repo, pull requests made in the spirit of this repository are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)