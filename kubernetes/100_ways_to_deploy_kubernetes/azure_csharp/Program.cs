using Pulumi;
using Pulumi.AzureNative.Resources;
using Pulumi.AzureNative.ContainerService;
using Pulumi.AzureNative.ContainerService.Inputs;

class MyStack : Stack
{
    public MyStack()
    {
        var resourceGroup = new ResourceGroup("myResourceGroup");

        var cluster = new ManagedCluster("myakscluster-csharp", new ManagedClusterArgs
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
            DnsPrefix = "myakscluster-csharp",
        });

        this.Kubeconfig = cluster.KubeConfigs.Apply(configs => configs[0].Value);
    }

    [Output] public Output<string> Kubeconfig { get; set; }
}
