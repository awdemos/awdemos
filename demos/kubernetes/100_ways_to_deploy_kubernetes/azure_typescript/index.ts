import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";

const resourceGroup = new azure.resources.ResourceGroup("myResourceGroup");

const cluster = new azure.containerservice.ManagedCluster(
  "myakscluster-typescript",
  {
    resourceGroupName: resourceGroup.name,
    agentPoolProfiles: [
      {
        count: 1,
        vmSize: "Standard_DS2_v2",
        name: "agentpool",
      },
    ],
    dnsPrefix: "myakscluster-typescript",
  },
);

export const kubeconfig = pulumi.all([
  resourceGroup.name,
  cluster.name,
]).apply(([rgName, clusterName]) =>
  azure.containerservice.listManagedClusterAccessProfile({
    resourceGroupName: rgName,
    resourceName: clusterName,
    roleName: "admin",
  }).then((profile) => profile.kubeConfig),
);
