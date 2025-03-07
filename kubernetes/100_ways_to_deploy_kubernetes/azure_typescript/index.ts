import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";

const resourceGroup = new azure.resources.ResourceGroup("myResourceGroup");

const cluster = new azure.containerservice.ManagedCluster("myakscluster-typescript", {
    resourceGroupName: resourceGroup.name,
    agentPoolProfiles: [{
        count: 1,
        vmSize: "Standard_DS2_v2",
        name: "agentpool",
    }],
    dnsPrefix: "myakscluster-typescript",
});

export const kubeconfig = cluster.kubeConfigs.apply(configs => configs[0].value);
