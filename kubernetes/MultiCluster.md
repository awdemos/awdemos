# Create k3d Multicluster

To install three clusters:

```
./multi_cluster.sh
```

To get the nodes of all your k3d clusters, you can use a combination of kubectl commands and context switching. Here's a step-by-step process to achieve this:

1. First, list all your k3d cluster contexts:

```bash
kubectl config get-contexts
```

2. Then, for each cluster, switch the context and get the nodes:

```bash
# For dev-cluster
kubectl config use-context dev-cluster
kubectl get nodes

# For prod-sim-cluster
kubectl config use-context prod-sim-cluster
kubectl get nodes

# For staging-cluster
kubectl config use-context staging-cluster
kubectl get nodes
```

Alternatively, you can use a bash loop to automate this process:

```bash
for cluster in dev-cluster prod-sim-cluster staging-cluster; do
    echo "Nodes in $cluster:"
    kubectl --context k3d-$cluster get nodes
    echo ""
done
```

This will list the nodes for each cluster without manually switching contexts. To get a list of all the clusters and their nodes use this:

```bash
for cluster in $(k3d cluster list -o json | jq -r '.[].name'); do
    echo "Cluster: $cluster"
    echo "Nodes:"
    kubectl --context k3d-$cluster get nodes -o wide
    echo
done

```


To make all three clusters aware of each other in the Cilium setup, you need to follow these steps:

0. Add env variables

```bash
export CLUSTER1="k3d-dev-cluster"
export CLUSTER2="k3d-staging-cluster"
export CLUSTER3="k3d-prod-sim-cluster"
```

1. Enable Cluster Mesh on all clusters:

```bash
cilium clustermesh enable --context $CLUSTER1 --service-type LoadBalancer
cilium clustermesh enable --context $CLUSTER2 --service-type LoadBalancer
cilium clustermesh enable --context $CLUSTER3 --service-type LoadBalancer
```

2. Verify that Cluster Mesh is enabled on all clusters:

```bash
cilium clustermesh status --context $CLUSTER1 --wait
cilium clustermesh status --context $CLUSTER2 --wait
cilium clustermesh status --context $CLUSTER3 --wait
```

3. Connect the clusters:

```bash
cilium clustermesh connect --context $CLUSTER1 --destination-context $CLUSTER2
cilium clustermesh connect --context $CLUSTER1 --destination-context $CLUSTER3
cilium clustermesh connect --context $CLUSTER2 --destination-context $CLUSTER3
```

Note that you only need to connect the clusters in one direction, as the connection will automatically be established in both directions[4][8].

4. Verify the connection status:

```bash
cilium clustermesh status --context $CLUSTER1 --wait
cilium clustermesh status --context $CLUSTER2 --wait
cilium clustermesh status --context $CLUSTER3 --wait
```

5. Test the connectivity between all clusters:

```bash
cilium connectivity test --context ${CLUSTER1} --multi-cluster ${CLUSTER2} ${CLUSTER3}
```

This setup will create a fully connected mesh between all three clusters, allowing them to communicate with each other and share services as if they were a single unified cluster[6][8].

Remember to ensure that each cluster has a unique cluster name and cluster ID when installing Cilium:

```bash
cilium install --set cluster.name=$CLUSTER1 --set cluster.id=1 --context $CLUSTER1
cilium install --set cluster.name=$CLUSTER2 --set cluster.id=2 --context $CLUSTER2
cilium install --set cluster.name=$CLUSTER3 --set cluster.id=3 --context $CLUSTER3
```

By following these steps, you'll have a fully functional Cilium Cluster Mesh connecting all three of your Kubernetes clusters, enabling seamless pod-to-pod communication, service discovery, and network policy enforcement across cluster boundaries[1][4][8].

Or just run

```
./install_cilium.sh
```

```
cilium hubble enable --context $CLUSTER1
cilium hubble enable --context $CLUSTER2
cilium hubble enable --context $CLUSTER3
```

To cleanup all your k3d clusters use:

```bash
k3d cluster delete --all

```
