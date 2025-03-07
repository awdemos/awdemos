#!/bin/bash

set -e

# Check prerequisites
check_prerequisites() {
    command -v pulumi >/dev/null 2>&1 || { echo >&2 "Pulumi is required but not installed. Aborting."; exit 1; }
}

# Function to create Pulumi project and files
create_pulumi_project() {
    local lang=$1
    local file=$2
    local cluster_name=$3
    
    mkdir -p "$lang"
    cd "$lang"
    
    # Initialize Pulumi project without creating a stack
    pulumi new aws-$lang --name eks-$lang --description "Minimal EKS cluster" --generate-only --yes
    
    # Create the main program file
    case $lang in
        typescript)
            cat > $file << EOL
import * as pulumi from "@pulumi/pulumi";
import * as eks from "@pulumi/eks";

const cluster = new eks.Cluster("${cluster_name}", {
    desiredCapacity: 1,
    minSize: 1,
    maxSize: 1,
    instanceType: "t3.micro",
});

export const kubeconfig = cluster.kubeconfig;
EOL
            ;;
        python)
            cat > $file << EOL
import pulumi
import pulumi_eks as eks

cluster = eks.Cluster("${cluster_name}",
    desired_capacity=1,
    min_size=1,
    max_size=1,
    instance_type="t3.micro"
)

pulumi.export("kubeconfig", cluster.kubeconfig)
EOL
            ;;
        go)
            cat > $file << EOL
package main

import (
    "github.com/pulumi/pulumi-eks/sdk/go/eks"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        cluster, err := eks.NewCluster(ctx, "${cluster_name}", &eks.ClusterArgs{
            DesiredCapacity: pulumi.Int(1),
            MinSize:         pulumi.Int(1),
            MaxSize:         pulumi.Int(1),
            InstanceType:    pulumi.String("t3.micro"),
        })
        if err != nil {
            return err
        }

        ctx.Export("kubeconfig", cluster.Kubeconfig)
        return nil
    })
}
EOL
            ;;
        csharp)
            cat > $file << EOL
using Pulumi;
using Pulumi.Eks;

class MyStack : Stack
{
    public MyStack()
    {
        var cluster = new Cluster("${cluster_name}", new ClusterArgs
        {
            DesiredCapacity = 1,
            MinSize = 1,
            MaxSize = 1,
            InstanceType = "t3.micro"
        });

        this.Kubeconfig = cluster.Kubeconfig;
    }

    [Output] public Output<string> Kubeconfig { get; set; }
}
EOL
            ;;
        yaml)
            cat > $file << EOL
name: eks-yaml
runtime: yaml
description: Minimal EKS cluster
resources:
  ${cluster_name}:
    type: eks:Cluster
    properties:
      desiredCapacity: 1
      minSize: 1
      maxSize: 1
      instanceType: t3.micro
outputs:
  kubeconfig: \${${cluster_name}.kubeconfig}
EOL
            ;;
    esac
    
    cd ..
}

# Main script
main() {
    check_prerequisites

    languages=("typescript" "python" "go" "csharp" "yaml")
    files=("index.ts" "__main__.py" "main.go" "Program.cs" "Pulumi.yaml")

    for i in "${!languages[@]}"; do
        lang=${languages[$i]}
        file=${files[$i]}
        cluster_name="my-cluster-${lang}"
        
        echo "Creating $lang project..."
        create_pulumi_project $lang $file $cluster_name
        
        echo "$lang project created successfully!"
        echo
    done

    echo "All projects created successfully!"
}

main

