import * as pulumi from "@pulumi/pulumi";
import * as eks from "@pulumi/eks";

const cluster = new eks.Cluster("my-cluster-typescript", {
    desiredCapacity: 1,
    minSize: 1,
    maxSize: 1,
    instanceType: "t3.micro",
});

export const kubeconfig = cluster.kubeconfig;
