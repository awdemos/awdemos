#!/bin/bash

# List of cluster names
CLUSTERS=("dev-cluster" "staging-cluster" "prod-sim-cluster")

# Function to install Cilium on a cluster
install_cilium() {
    local cluster=$1
    echo "Installing Cilium on cluster: $cluster"
    cilium install --context k3d-$cluster --wait
    cilium status --context k3d-$cluster --wait
}

# Install Cilium CLI if not already installed
#if ! command -v cilium &> /dev/null; then
#    echo "Installing Cilium CLI..."
#    curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
#    sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
#    rm cilium-linux-amd64.tar.gz
#fi

# Install Cilium on each cluster
for cluster in "${CLUSTERS[@]}"; do
    install_cilium $cluster
done

echo "Cilium installation completed on all clusters."

