import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const cluster = new gcp.container.Cluster("mygkecluster-typescript", {
    initialNodeCount: 1,
    minMasterVersion: "latest",
    nodeVersion: "latest",
    nodeConfig: {
        machineType: "n1-standard-1",
    },
});

export const kubeconfig = cluster.masterAuth.clusterCaCertificate;
