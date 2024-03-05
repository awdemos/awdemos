This document outlines a series of commands useful for managing a Kubernetes cluster with Talos and other tools.

## Talos Commands

List Talos Config Contexts:
```talosctl config contexts```

Bootstrap Talos Cluster:

```talosctl bootstrap --talosconfig=/home/a/.talos/talosconfig --nodes=10.5.0.2```

Configure New Cluster Context:

```
talosctl config new my-cluster --endpoints 10.5.0.2
talosctl config context my-cluster
talosctl config endpoint 10.5.0.2
talosctl config node 10.5.0.2
```

## Docker Commands
Remove All Containers of a Specific Image:

```docker rm --force $(docker ps -aq --filter "ancestor=ghcr.io/siderolabs/talos:v1.6.5")```

Remove Docker Network:

```docker network rm my-new-cluster-v6BvU```

## Kubernetes Commands
Set KUBECONFIG Environment Variable:

```export KUBECONFIG=/home/a/.talos/kubeconfig```

Get Kubernetes Nodes:

```kubectl --kubeconfig=/home/a/.talos/kubeconfig get nodes```

## Omni Commands
Validate and Sync Cluster Template:

```omnictl cluster template validate -f omnictl-cluster-create.yaml
omnictl cluster template sync --file omnictl-cluster-create.yaml
```

Generate and Export Kubeconfig for the Cluster:

```omnictl kubeconfig -c my-cluster > my-cluster-kubeconfig.yaml
export KUBECONFIG=$(pwd)/my-cluster-kubeconfig.yaml```

## Additional Tools
Install kubelogin (needed for first time login):

```curl -LO https://github.com/int128/kubelogin/releases/download/v1.28.0/kubelogin_linux_amd64.zip
unzip kubelogin_linux_amd64.zip
sudo mv kubelogin /usr/local/bin/```

Set PATH for Krew:

```export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"```

My system was defaulting to using w3m for authentication with the oidc provider and I had a better experience with lynx:

```sudo apt install lynx```

OIDC Login:
```/home/a/.krew/bin/kubectl-oidc_login get-token --oidc-issuer-url=https://awdemos.omni.siderolabs.io/oidc --oidc-client-id=native --oidc-extra-scope=cluster:my-cluster```

Export Control Plane IP:
```export CONTROL_PLANE_IP=10.0.2.15```

Check Cluster Status:
```omnictl cluster status my-cluster```

Issue Certificates with acme.sh:
```acme.sh --issue --dns -d example.com -d *.example.com --yes-I-know-dns-manual-mode-enough-go-ahead-please --force```

Run Omni Container:
```docker run \
--net=host \
--cap-add=NET_ADMIN \
-v $PWD/etcdb:/out/etcd \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $PWD/chain.crt:/tls.crt \
-v $PWD/tls.key:/tls.key \
-v $PWD/omni.asc:/omni.asc \
ghcr.io/siderolabs/omni```

Another example:
```docker run \
  --net=host \
  --cap-add=NET_ADMIN \
  -v $PWD/etcd:/_out/etcd \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/cert.pem:/tls.crt \
  -v $HOME/privkey.pem:/tls.key \
  -v $PWD/omni.asc:/omni.asc \
  ghcr.io/siderolabs/omni:latest \
    --account-id=${OMNI_ACCOUNT_UUID} \
    --name=onprem-omni \
    --cert=/tls.crt \
    --key=/tls.key \
    --siderolink-api-cert=/tls.crt \
    --siderolink-api-key=/tls.key \
    --private-key-source=file:///omni.asc \
    --event-sink-port=8091 \
    --bind-addr=0.0.0.0:443 \
    --siderolink-api-bind-addr=0.0.0.0:8090 \
    --k8s-proxy-bind-addr=0.0.0.0:8100 \
    --advertised-api-url=https://${DOMAIN}/ \
    --siderolink-api-advertised-url=https://${DOMAIN}:8090/ \
    --siderolink-wireguard-advertised-addr=192.168.1.60:50180 \
    --advertised-kubernetes-proxy-url=https://${DOMAIN}:8100/ \
    --auth-auth0-enabled=true \
    --auth-auth0-domain=${AUTH0_DOMAIN} \
    --auth-auth0-client-id=${AUTH0_CLIENT_ID} \
    --initial-users=${AUTH0_USER_EMAIL}
    ```