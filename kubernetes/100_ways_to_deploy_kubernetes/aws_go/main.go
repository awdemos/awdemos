package main

import (
    "github.com/pulumi/pulumi-eks/sdk/go/eks"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        cluster, err := eks.NewCluster(ctx, "my-cluster-go", &eks.ClusterArgs{
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
