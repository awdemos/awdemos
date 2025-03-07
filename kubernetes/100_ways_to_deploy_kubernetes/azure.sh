#!/bin/bash

set -e

check_prerequisites() {
    command -v pulumi >/dev/null 2>&1 || { echo >&2 "Pulumi is required but not installed. Aborting."; exit 1; }
}

create_pulumi_project() {
    local lang=$1
    local file=$2
    local cluster_name=$3
    local dir_name="azure_${lang}"
    
    mkdir -p "$dir_name"
    cd "$dir_name"
    
    pulumi new azure-$lang --name azure-aks-$lang --description "Azure AKS Cluster" --generate-only --yes
    
    case $lang in
        typescript)
            cat > $file << EOL
import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";

const resourceGroup = new azure.resources.ResourceGroup("myResourceGroup");

const cluster = new azure.containerservice.ManagedCluster("${cluster_name}", {
    resourceGroupName: resourceGroup.name,
    agentPoolProfiles: [{
        count: 1,
        vmSize: "Standard_DS2_v2",
        name: "agentpool",
    }],
    dnsPrefix: "${cluster_name}",
});

export const kubeconfig = cluster.kubeConfigs.apply(configs => configs[0].value);
EOL
            ;;
        python)
            cat > $file << EOL
import pulumi
from pulumi_azure_native import resources, containerservice

resource_group = resources.ResourceGroup("myResourceGroup")

cluster = containerservice.ManagedCluster("${cluster_name}",
    resource_group_name=resource_group.name,
    agent_pool_profiles=[{
        "count": 1,
        "vm_size": "Standard_DS2_v2",
        "name": "agentpool",
    }],
    dns_prefix="${cluster_name}")

pulumi.export("kubeconfig", cluster.kube_configs.apply(lambda configs: configs[0].value))
EOL
            ;;
        go)
            cat > $file << EOL
package main

import (
    "github.com/pulumi/pulumi-azure-native/sdk/go/azure/resources"
    "github.com/pulumi/pulumi-azure-native/sdk/go/azure/containerservice"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        resourceGroup, err := resources.NewResourceGroup(ctx, "myResourceGroup", nil)
        if err != nil {
            return err
        }

        cluster, err := containerservice.NewManagedCluster(ctx, "${cluster_name}", &containerservice.ManagedClusterArgs{
            ResourceGroupName: resourceGroup.Name,
            AgentPoolProfiles: containerservice.ManagedClusterAgentPoolProfileArray{
                &containerservice.ManagedClusterAgentPoolProfileArgs{
                    Count:   pulumi.Int(1),
                    VmSize:  pulumi.String("Standard_DS2_v2"),
                    Name:    pulumi.String("agentpool"),
                },
            },
            DnsPrefix: pulumi.String("${cluster_name}"),
        })
        if err != nil {
            return err
        }

        ctx.Export("kubeconfig", cluster.KubeConfigs.ApplyT(func(configs []containerservice.ManagedClusterKubeConfigArgs) (string, error) {
            return *configs[0].Value, nil
        }).(pulumi.StringOutput))

        return nil
    })
}
EOL
            ;;
        csharp)
            cat > $file << EOL
using Pulumi;
using Pulumi.AzureNative.Resources;
using Pulumi.AzureNative.ContainerService;
using Pulumi.AzureNative.ContainerService.Inputs;

class MyStack : Stack
{
    public MyStack()
    {
        var resourceGroup = new ResourceGroup("myResourceGroup");

        var cluster = new ManagedCluster("${cluster_name}", new ManagedClusterArgs
        {
            ResourceGroupName = resourceGroup.Name,
            AgentPoolProfiles = 
            {
                new ManagedClusterAgentPoolProfileArgs
                {
                    Count = 1,
                    VmSize = "Standard_DS2_v2",
                    Name = "agentpool",
                }
            },
            DnsPrefix = "${cluster_name}",
        });

        this.Kubeconfig = cluster.KubeConfigs.Apply(configs => configs[0].Value);
    }

    [Output] public Output<string> Kubeconfig { get; set; }
}
EOL
            ;;
        yaml)
            cat > $file << EOL
name: azure-aks-yaml
runtime: yaml
description: Azure AKS Cluster
resources:
  resourceGroup:
    type: azure-native:resources:ResourceGroup
  ${cluster_name}:
    type: azure-native:containerservice:ManagedCluster
    properties:
      resourceGroupName: \${resourceGroup.name}
      agentPoolProfiles:
        - count: 1
          vmSize: Standard_DS2_v2
          name: agentpool
      dnsPrefix: ${cluster_name}
outputs:
  kubeconfig: \${${cluster_name}.kubeConfigs[0].value}
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
        cluster_name="myakscluster-${lang}"
        
        echo "Creating azure_$lang project..."
        create_pulumi_project $lang $file $cluster_name
        
        echo "azure_$lang project created successfully!"
        echo
    done

    echo "All projects created successfully!"
}

main

