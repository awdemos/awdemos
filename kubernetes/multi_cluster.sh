#!/bin/bash

# Function to create a cluster
create_cluster() {
    local name=$1
    local servers=$2
    local agents=$3
    local api_port=$4

    echo "Creating cluster: $name"
    k3d cluster create $name \
        --servers $servers \
        --agents $agents \
        --api-port $api_port \
        --k3s-arg '--flannel-backend=none@server:*' \
        --k3s-arg '--disable-network-policy@server:*' \
        --k3s-arg '--disable=traefik@server:*' \
        --servers-memory 2GB \
        --agents-memory 4GB \
        --wait
}

# Create Cluster 1: Development Cluster (1 server, 3 agents)
create_cluster "dev-cluster" 1 3 "127.0.0.1:6443"

# Create Cluster 2: Staging Cluster (1 server, 3 agents)
create_cluster "staging-cluster" 1 3 "127.0.0.1:6446"

# Create Cluster 3: Production Simulation Cluster (1 server, 3 agents)
create_cluster "prod-sim-cluster" 1 3 "127.0.0.1:6445"

# List all clusters
echo "Listing all created clusters:"
k3d cluster list

# Set up kubectl contexts
for cluster in dev-cluster staging-cluster prod-sim-cluster; do
    k3d kubeconfig get $cluster > $HOME/.kube/$cluster-config
    export KUBECONFIG=$HOME/.kube/$cluster-config:$KUBECONFIG
done

# Merge kubeconfig files
k3d kubeconfig merge dev-cluster staging-cluster prod-sim-cluster -o $HOME/.kube/config

echo "Setup complete! You now have three k3d clusters running locally, ready for Cilium installation."
echo "Use 'kubectl config use-context k3d-<cluster-name>' to switch between clusters."
echo "Install Cilium on each cluster using: cilium install --context k3d-<cluster-name>"

