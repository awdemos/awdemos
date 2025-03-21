#!/bin/bash

set -e

check_prerequisites() {
    command -v pulumi >/dev/null 2>&1 || { echo >&2 "Pulumi is required but not installed. Aborting."; exit 1; }
}

create_pulumi_project() {
    local lang=$1
    local file=$2
    local cluster_name=$3
    local dir_name="gcp_${lang}"
    
    mkdir -p "$dir_name"
    cd "$dir_name"
    
    pulumi new gcp-$lang --name gcp-gke-$lang --description "GCP GKE Cluster" --generate-only --yes
    
    case $lang in
        typescript)
            cat > $file << EOL
import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const cluster = new gcp.container.Cluster("${cluster_name}", {
    initialNodeCount: 1,
    minMasterVersion: "latest",
    nodeVersion: "latest",
    nodeConfig: {
        machineType: "n1-standard-1",
    },
});

export const kubeconfig = cluster.masterAuth.clusterCaCertificate;
EOL
            ;;
        python)
            cat > $file << EOL
import pulumi
from pulumi_gcp import container

cluster = container.Cluster("${cluster_name}",
    initial_node_count=1,
    min_master_version="latest",
    node_version="latest",
    node_config={
        "machine_type": "n1-standard-1",
    })

pulumi.export("kubeconfig", cluster.master_auth.cluster_ca_certificate)
EOL
            ;;
        go)
            cat > $file << EOL
package main

import (
    "github.com/pulumi/pulumi-gcp/sdk/v6/go/gcp/container"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        cluster, err := container.NewCluster(ctx, "${cluster_name}", &container.ClusterArgs{
            InitialNodeCount: pulumi.Int(1),
            MinMasterVersion: pulumi.String("latest"),
            NodeVersion:      pulumi.String("latest"),
            NodeConfig: &container.ClusterNodeConfigArgs{
                MachineType: pulumi.String("n1-standard-1"),
            },
        })
        if err != nil {
            return err
        }

        ctx.Export("kubeconfig", cluster.MasterAuth.ClusterCaCertificate())
        return nil
    })
}
EOL
            ;;
        csharp)
            cat > $file << EOL
using Pulumi;
using Pulumi.Gcp.Container;

class MyStack : Stack
{
    public MyStack()
    {
        var cluster = new Cluster("${cluster_name}", new ClusterArgs
        {
            InitialNodeCount = 1,
            MinMasterVersion = "latest",
            NodeVersion = "latest",
            NodeConfig = new ClusterNodeConfigArgs
            {
                MachineType = "n1-standard-1",
            },
        });

        this.Kubeconfig = cluster.MasterAuth.Apply(auth => auth.ClusterCaCertificate);
    }

    [Output] public Output<string> Kubeconfig { get; set; }
}
EOL
            ;;
        yaml)
            cat > $file << EOL
name: gcp-gke-yaml
runtime: yaml
description: GCP GKE Cluster
resources:
  ${cluster_name}:
    type: gcp:container:Cluster
    properties:
      initialNodeCount: 1
      minMasterVersion: latest
      nodeVersion: latest
      nodeConfig:
        machineType: n1-standard-1
outputs:
  kubeconfig: \${${cluster_name}.masterAuth.clusterCaCertificate}
EOL
            ;;
    esac
    
    cd ..
}

main() {
    check_prerequisites

    languages=("typescript" "python" "go" "csharp" "yaml")
    files=("index.ts" "__main__.py" "main.go" "Program.cs" "Pulumi.yaml")

    for i in "${!languages[@]}"; do
        lang=${languages[$i]}
        file=${files[$i]}
        cluster_name="mygkecluster-${lang}"
        
        echo "Creating gcp_$lang project..."
        create_pulumi_project $lang $file $cluster_name
        
        echo "gcp_$lang project created successfully!"
        echo
    done

    echo "All projects created successfully!"
}

main

