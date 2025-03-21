#!/bin/bash

# Script to create a Talos Linux cluster in Podman containers on Bluefin Linux
set -e

echo "====== Talos Linux Cluster Setup on Bluefin ======"
echo "This script will set up a Talos Linux cluster using Podman containers"

# Check if podman is installed
if ! command -v podman &> /dev/null; then
    echo "Podman is not installed. Please install it using 'rpm-ostree install podman' and reboot."
    exit 1
fi

# Check if talosctl is installed, install if needed
if ! command -v talosctl &> /dev/null; then
    echo "Installing talosctl..."
    # Using brew as recommended in the Talos docs
    if command -v brew &> /dev/null; then
        brew install siderolabs/tap/talosctl
    else
        echo "Homebrew not found. Installing it first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install siderolabs/tap/talosctl
    fi
fi

# Check if kubectl is installed, install if needed
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    if command -v brew &> /dev/null; then
        brew install kubernetes-cli
    else
        echo "Error: Homebrew not available. Please install kubectl manually."
        exit 1
    fi
fi

# Define cluster parameters
CLUSTER_NAME="talos-cluster"
CONTROL_PLANE_NODES=1
WORKER_NODES=2

echo "Creating Talos cluster with ${CONTROL_PLANE_NODES} control plane node(s) and ${WORKER_NODES} worker node(s)..."

# Set required environment variables
export TALOSCONFIG="${HOME}/.talos/config"

# Create the Talos cluster using talosctl
talosctl cluster create \
    --name ${CLUSTER_NAME} \
    --controlplanes ${CONTROL_PLANE_NODES} \
    --workers ${WORKER_NODES} \
    --wait \

# Configure talosctl to communicate with the cluster
echo "Configuring talosctl endpoints..."
FIRST_CP_IP=$(talosctl config info -o json | jq -r '.endpoints[0]')
talosctl config node "${FIRST_CP_IP}"

# Get kubeconfig
echo "Fetching kubeconfig..."
talosctl kubeconfig --nodes "${FIRST_CP_IP}" --endpoints "${FIRST_CP_IP}"

echo ""
echo "====== Talos Linux Cluster Setup Complete ======"
echo ""
echo "Your Talos Kubernetes cluster is now running in Podman containers."
echo ""
echo "To interact with Talos nodes, use: talosctl [command]"
echo "To interact with Kubernetes, use: kubectl [command]"
echo ""
echo "When you're done with the cluster, you can remove it with:"
echo "  talosctl cluster destroy --name ${CLUSTER_NAME}"
echo ""

