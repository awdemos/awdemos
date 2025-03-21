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

        cluster, err := containerservice.NewManagedCluster(ctx, "myakscluster-go", &containerservice.ManagedClusterArgs{
            ResourceGroupName: resourceGroup.Name,
            AgentPoolProfiles: containerservice.ManagedClusterAgentPoolProfileArray{
                &containerservice.ManagedClusterAgentPoolProfileArgs{
                    Count:   pulumi.Int(1),
                    VmSize:  pulumi.String("Standard_DS2_v2"),
                    Name:    pulumi.String("agentpool"),
                },
            },
            DnsPrefix: pulumi.String("myakscluster-go"),
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
