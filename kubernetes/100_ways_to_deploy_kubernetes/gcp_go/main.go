package main

import (
    "github.com/pulumi/pulumi-gcp/sdk/v6/go/gcp/container"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        cluster, err := container.NewCluster(ctx, "mygkecluster-go", &container.ClusterArgs{
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
