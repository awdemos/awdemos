#!/usr/bin/env bash
# One-time host bootstrap. MANUAL GATE: run as `sudo bash 00-bootstrap-host.sh`.
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

K3S=/var/home/a/.local/bin/k3s
CTK=/var/home/a/.local/bin/nvidia-ctk

echo "==> subuid/subgid for rootless podman (user a)"
grep -q '^a:' /etc/subuid || usermod --add-subuids 100000-165535 a
grep -q '^a:' /etc/subgid || usermod --add-subgids 100000-165535 a

echo "==> local registry storage"
mkdir -p /var/lib/inference-registry && chown 1000:1000 /var/lib/inference-registry

echo "==> k3s systemd unit"
cat > /etc/systemd/system/k3s.service <<'UNIT'
[Unit]
Description=k3s (inference-platform)
After=network-online.target
Wants=network-online.target
[Service]
ExecStart=/var/home/a/.local/bin/k3s server --disable=traefik --disable=servicelb --write-kubeconfig-mode=644 --flannel-backend=host-gw
Restart=always
Type=notify
Delegate=yes
KillMode=process
LimitNOFILE=1048576
[Install]
WantedBy=multi-user.target
UNIT

echo "==> insecure localhost registry (must exist before first start)"
mkdir -p /etc/rancher/k3s
cat > /etc/rancher/k3s/registries.yaml <<'YAML'
mirrors:
  "localhost:5000":
    endpoint:
      - "http://localhost:5000"
YAML

systemctl daemon-reload
systemctl enable --now k3s
until "$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready'; do sleep 2; done
echo "==> k3s up"

echo "==> nvidia containerd runtime (persists via config.toml.tmpl)"
"$CTK" runtime configure --runtime=containerd \
  --config=/var/lib/rancher/k3s/agent/etc/containerd/config.toml
sed -i 's/^default_runtime_name = "runc"$/default_runtime_name = "nvidia"/' \
  /var/lib/rancher/k3s/agent/etc/containerd/config.toml
grep -q '^default_runtime_name = "nvidia"' /var/lib/rancher/k3s/agent/etc/containerd/config.toml
cp /var/lib/rancher/k3s/agent/etc/containerd/config.toml \
   /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
systemctl restart k3s
until "$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready'; do sleep 2; done

echo "==> kubeconfig for user a"
mkdir -p /var/home/a/.kube
cp /etc/rancher/k3s/k3s.yaml /var/home/a/.kube/config
chown 1000:1000 /var/home/a/.kube/config
chmod 600 /var/home/a/.kube/config

"$K3S" kubectl get nodes -o wide
echo "BOOTSTRAP OK"
