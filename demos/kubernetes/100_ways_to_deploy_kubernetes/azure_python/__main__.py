import pulumi
from pulumi_azure_native import resources, containerservice

resource_group = resources.ResourceGroup("myResourceGroup")

cluster = containerservice.ManagedCluster("myakscluster-python",
    resource_group_name=resource_group.name,
    agent_pool_profiles=[{
        "count": 1,
        "vm_size": "Standard_DS2_v2",
        "name": "agentpool",
    }],
    dns_prefix="myakscluster-python")

pulumi.export("kubeconfig", cluster.kube_configs.apply(lambda configs: configs[0].value))
