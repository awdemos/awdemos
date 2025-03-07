using Pulumi;
using Pulumi.Eks;

class MyStack : Stack
{
    public MyStack()
    {
        var cluster = new Cluster("my-cluster-csharp", new ClusterArgs
        {
            DesiredCapacity = 1,
            MinSize = 1,
            MaxSize = 1,
            InstanceType = "t3.micro"
        });

        this.Kubeconfig = cluster.Kubeconfig;
    }

    [Output] public Output<string> Kubeconfig { get; set; }
}
