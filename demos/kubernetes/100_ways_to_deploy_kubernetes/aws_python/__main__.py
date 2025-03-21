import pulumi
import pulumi_eks as eks

cluster = eks.Cluster("my-cluster-python",
    desired_capacity=1,
    min_size=1,
    max_size=1,
    instance_type="t3.micro"
)

pulumi.export("kubeconfig", cluster.kubeconfig)
