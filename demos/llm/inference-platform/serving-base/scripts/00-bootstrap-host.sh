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
ExecStart=/var/home/a/.local/bin/k3s server --disable=traefik --disable=servicelb --flannel-backend=host-gw
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
# Intentionally insecure: localhost-only registry for a single-user demo box.
cat > /etc/rancher/k3s/registries.yaml <<'YAML'
mirrors:
  "localhost:5000":
    endpoint:
      - "http://localhost:5000"
YAML

systemctl daemon-reload
systemctl enable --now k3s
for _ in $(seq 1 90); do
  "$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready' && break
  sleep 2
done
"$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready' \
  || { journalctl -u k3s --no-pager -n 100; exit 1; }
echo "==> k3s up"

echo "==> nvidia containerd runtime (drop-in + config.toml.tmpl)"
"$CTK" runtime configure --runtime=containerd --set-as-default=true \
  --config=/var/lib/rancher/k3s/agent/etc/containerd/config.toml \
  || { echo "ERROR: nvidia-ctk runtime configure failed"; exit 1; }
grep -qE '^\s*default_runtime_name\s*=\s*"nvidia"' /etc/containerd/conf.d/99-nvidia.toml \
  || { echo "ERROR: nvidia default runtime missing from drop-in"; exit 1; }
cp /var/lib/rancher/k3s/agent/etc/containerd/config.toml \
   /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
systemctl restart k3s
for _ in $(seq 1 90); do
  "$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready' && break
  sleep 2
done
"$K3S" kubectl get nodes 2>/dev/null | grep -q ' Ready' \
  || { journalctl -u k3s --no-pager -n 100; exit 1; }

echo "==> kubeconfig for user a"
mkdir -p /var/home/a/.kube
cp /etc/rancher/k3s/k3s.yaml /var/home/a/.kube/config
chown 1000:1000 /var/home/a/.kube/config
chmod 600 /var/home/a/.kube/config

"$K3S" kubectl get nodes -o wide
echo "BOOTSTRAP OK"
