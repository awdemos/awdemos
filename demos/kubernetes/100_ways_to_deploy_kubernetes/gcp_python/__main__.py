import pulumi
from pulumi_gcp import container

cluster = container.Cluster("mygkecluster-python",
    initial_node_count=1,
    min_master_version="latest",
    node_version="latest",
    node_config={
        "machine_type": "n1-standard-1",
    })

pulumi.export("kubeconfig", cluster.master_auth.cluster_ca_certificate)
