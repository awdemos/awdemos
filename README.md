# README

## Project Overview

This repository contains a couple of demo projects that sets up some interesting services in AWS and GCP. 

Three of these projects use Pulumi infrastructure as code to dpeloy resources into AWS in Go sourced files. For more informaiton please see (https://www.pulumi.com/docs/languages-sdks/go/)

The infrastructure includes a VPC, a public subnet, an internet gateway, a route table, a security group, and an EC2 instance. The EC2 instance is configured to install and run an Ethereum node using the `geth` command.

The Fargate project demonstrates how to build a local docker container and push it into an AWS ECR repository presumebly for later ingestion into kubernetes.

## Prerequisites

- Terraform
- Pulumi
- AWS/GCP CLI configured with your credentials

## Setup

1. Clone the repository:

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

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)