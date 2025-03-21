using Pulumi;
using Pulumi.Gcp.Container;

class MyStack : Stack
{
    public MyStack()
    {
        var cluster = new Cluster("mygkecluster-csharp", new ClusterArgs
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
