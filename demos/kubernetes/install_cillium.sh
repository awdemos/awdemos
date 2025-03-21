
#

set -e  # Exit immediately if a command exits with a non-zero status

CLUSTERS=("dev-cluster" "staging-cluster" "prod-sim-cluster")
CILIUM_NAMESPACE="kube-system"
TETRAGON_NAMESPACE="kube-system"

# Add Cilium and Tetragon Helm repositories
helm repo add cilium https://helm.cilium.io
helm repo update

for cluster in "${CLUSTERS[@]}"; do
    echo "Processing cluster: $cluster"
    
    # Check if the cluster exists
    if ! k3d cluster list | grep -q "$cluster"; then
        echo "Error: Cluster $cluster does not exist. Skipping."
        continue
    fi
    
    # Switch context
    if ! kubectl config use-context "k3d-$cluster" &>/dev/null; then
        echo "Error: Failed to switch context to k3d-$cluster. Skipping."
        continue
    fi
    
    # Set cluster ID based on cluster name
    case $cluster in
        "dev-cluster")
            CLUSTER_ID=1
            ;;
        "staging-cluster")
            CLUSTER_ID=2
            ;;
        "prod-sim-cluster")
            CLUSTER_ID=3
            ;;
        *)
            echo "Error: Unknown cluster $cluster. Skipping."
            continue
            ;;
    esac
    
    # Install/upgrade Cilium
    if helm upgrade --install cilium cilium/cilium \
       --version 1.17.0 \
        --namespace "$CILIUM_NAMESPACE" \
        --set kubeProxyReplacement=false \
        --set ipam.mode=kubernetes \
        --set cluster.id="$CLUSTER_ID" \
        --set cluster.name="$cluster" \
        --wait \
        --timeout 5m; then
        echo "Successfully installed/upgraded Cilium on $cluster"
    else
        echo "Error: Failed to install/upgrade Cilium on $cluster"
        continue
    fi

    cilium clustermesh enable --context k3d-dev-cluster --service-type LoadBalancer
    cilium clustermesh enable --context k3d-staging-cluster --service-type LoadBalancer
    cilium clustermesh enable --context k3d-prod-sim-cluster --service-type LoadBalancer

    cilium hubble enable --ui --context k3d-dev-cluster
    cilium hubble enable --ui --context k3d-staging-cluster
    cilium hubble enable --ui --context k3d-prod-sim-cluster



    # Install/upgrade Tetragon
    if helm upgrade --install tetragon cilium/tetragon \
        --namespace "$TETRAGON_NAMESPACE" \
        --set tetragon.grpc.address=":4447" \
        --set tetragon.btf="" \
        --wait \
        --timeout 5m; then
        echo "Successfully installed/upgraded Tetragon on $cluster"
    else
        echo "Error: Failed to install/upgrade Tetragon on $cluster"
    fi
done

echo "Cilium and Tetragon installation process completed."



