#!/bin/bash

# Installs Talos Kubernetes into Docker nodes. Requires Docker, talosctl, openai key.
# Define placeholders for user-specific values
TALOS_CONFIG_DIR="/home/a/.talos/" # change your dir as needed
TALOS_CONFIG="/home/a/.talos/talosconfig" # change your dir as needed
CLUSTER_NAME="my-new-cluster-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)"
CONTEXT_NAME="context-${CLUSTER_NAME}"
CONTROL_PLANE_IPS="10.5.0.2"
WORKER_IPS="10.5.0.3"
KUBERNETES_VERSION="v1.29.1"
TALOS_VERSION="v0.164"
DNS_DOMAIN="cluster.local"
NETWORK_CIDR="10.5.0.0/24"
NAMESERVERS="8.8.8.8,8.8.4.4"

echo "Cluster Name: ${CLUSTER_NAME}"
echo "Control Plane IPs: ${CONTROL_PLANE_IPS}"
echo "First Control Plane IP: ${CONTROL_PLANE_IPS%%,*}"

if [ ! -f /usr/local/bin/talosctl ]; then
    curl -sL https://talos.dev/install | sh
else
    echo "talosctl is already installed."
fi

# Create a new talosctl context and set it as the current context
talosctl config new ${CONTEXT_NAME} --nodes ${CONTROL_PLANE_IPS} --endpoints ${CONTROL_PLANE_IPS} --talosconfig "${TALOS_CONFIG}"
talosctl config add ${CONTEXT_NAME} --nodes ${CONTROL_PLANE_IPS} --endpoints ${CONTROL_PLANE_IPS}

talosctl config info

# Create the Talos cluster
talosctl cluster create --name "${CLUSTER_NAME}" \
    --endpoints "https://${CONTROL_PLANE_IPS%%,*}:6443" \
    --kubernetes-version "${KUBERNETES_VERSION}" \
    --talos-version "${TALOS_VERSION}" \
    --talosconfig "${TALOS_CONFIG}" \
    --crashdump

talosctl bootstrap --talosconfig "${TALOS_CONFIG}" --nodes "${CONTROL_PLANE_IPS}" --endpoints "${CONTROL_PLANE_IPS}"
talosctl kubeconfig --nodes "${CONTROL_PLANE_IPS}" --endpoints "${CONTROL_PLANE_IPS}" --merge=true > "${TALOS_CONFIG_DIR}/kubeconfig"

talosctl dashboard --nodes "${CONTROL_PLANE_IPS}"

echo "Talos cluster setup initiated. Please check the status of the nodes."
echo "kubectl --kubeconfig=/home/a/.kube/config get nodes"

# Commands for cleanup are commented out as per request
# To delete the cluster, uncomment and run the following commands:

# echo "Destroying Talos cluster..."
# talosctl cluster destroy --name "${CLUSTER_NAME}"
# docker rm --force $(docker ps -aq --filter "ancestor=ghcr.io/siderolabs/talos:v1.6.5")
# docker network rm my-new-cluster-
