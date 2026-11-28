#!/usr/bin/env bash
# One-time host bootstrap for the D1 serving-base demo.
#
# MANUAL GATE: this script changes host-level state (systemd, /etc, registry
# storage, subuid/subgid). Review it before running. Run as root:
#
#   sudo bash 00-bootstrap-host.sh
#
# All host-specific paths and the account name are parameters. Defaults match
# the original single-user demo box; override them via the environment. sudo
# strips most variables, so pass overrides explicitly, for example:
#
#   sudo DEMO_USER=alice K3S_SRC=/home/alice/bin/k3s bash 00-bootstrap-host.sh
#
# Rollback: see 99-unbootstrap-host.sh and ../README.md.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

# ── Parameters ─────────────────────────────────────────────────────────────────
DEMO_USER="${DEMO_USER:-${SUDO_USER:-a}}"
id "$DEMO_USER" >/dev/null 2>&1 || { echo "ERROR: no such user: $DEMO_USER"; exit 1; }

DEMO_UID="$(id -u "$DEMO_USER")"
DEMO_GID="$(id -g "$DEMO_USER")"
DEMO_HOME="$(getent passwd "$DEMO_USER" | cut -d: -f6)"
[ -n "$DEMO_HOME" ] || { echo "ERROR: cannot determine home for $DEMO_USER"; exit 1; }

K3S_SRC="${K3S_SRC:-$DEMO_HOME/.local/bin/k3s}"
CTK_BIN="${CTK_BIN:-$DEMO_HOME/.local/bin/nvidia-ctk}"
K3S_BIN="${K3S_BIN:-/usr/local/bin/k3s}"
REGISTRY_DIR="${REGISTRY_DIR:-/var/lib/inference-registry}"
K3S_CONFIG_DIR="${K3S_CONFIG_DIR:-/etc/rancher/k3s}"
K3S_UNIT="${K3S_UNIT:-/etc/systemd/system/k3s.service}"
KUBECONFIG_DIR="${KUBECONFIG_DIR:-$DEMO_HOME/.kube}"

for required in "$K3S_SRC" "$CTK_BIN"; do
  [ -x "$required" ] || { echo "ERROR: missing or non-executable: $required"; exit 1; }
done

echo "==> Configuration"
echo "    user=$DEMO_USER uid=$DEMO_UID gid=$DEMO_GID home=$DEMO_HOME"
echo "    k3s source=$K3S_SRC -> $K3S_BIN"
echo "    nvidia-ctk=$CTK_BIN"
echo "    registry=$REGISTRY_DIR"
echo "    k3s config=$K3S_CONFIG_DIR"
echo "    systemd unit=$K3S_UNIT"
echo "    kubeconfig=$KUBECONFIG_DIR/config"

# ── Install ────────────────────────────────────────────────────────────────────
echo "==> install k3s binary (SELinux: init cannot exec from home)"
install -m 0755 "$K3S_SRC" "$K3S_BIN"

echo "==> subuid/subgid for rootless podman ($DEMO_USER)"
grep -q "^${DEMO_USER}:" /etc/subuid || usermod --add-subuids 100000-165535 "$DEMO_USER"
grep -q "^${DEMO_USER}:" /etc/subgid || usermod --add-subgids 100000-165535 "$DEMO_USER"

echo "==> local registry storage"
mkdir -p "$REGISTRY_DIR" && chown "${DEMO_UID}:${DEMO_GID}" "$REGISTRY_DIR"

echo "==> k3s systemd unit"
cat > "$K3S_UNIT" <<UNIT
[Unit]
Description=k3s (inference-platform)
After=network-online.target
Wants=network-online.target
[Service]
ExecStart=$K3S_BIN server --disable=traefik --disable=servicelb --flannel-backend=host-gw
Restart=always
Type=notify
Delegate=yes
KillMode=process
LimitNOFILE=1048576
[Install]
WantedBy=multi-user.target
UNIT

echo "==> insecure localhost registry (must exist before first start)"
mkdir -p "$K3S_CONFIG_DIR"
# Intentionally insecure: localhost-only registry for a single-user demo box.
cat > "$K3S_CONFIG_DIR/registries.yaml" <<'YAML'
mirrors:
  "localhost:5000":
    endpoint:
      - "http://localhost:5000"
YAML

wait_for_ready() {
  local unit_name="$1"
  for _ in $(seq 1 90); do
    "$K3S_BIN" kubectl get nodes 2>/dev/null | grep -q ' Ready' && return 0
    sleep 2
  done
  journalctl -u "$unit_name" --no-pager -n 100
  return 1
}

UNIT_NAME="$(basename "$K3S_UNIT" .service)"
systemctl daemon-reload
systemctl enable --now "$UNIT_NAME"
wait_for_ready "$UNIT_NAME" || exit 1
echo "==> k3s up"

echo "==> nvidia containerd runtime (drop-in + config.toml.tmpl)"
"$CTK_BIN" runtime configure --runtime=containerd --set-as-default=true \
  --config=/var/lib/rancher/k3s/agent/etc/containerd/config.toml \
  || { echo "ERROR: nvidia-ctk runtime configure failed"; exit 1; }
grep -qE '^\s*default_runtime_name\s*=\s*"nvidia"' /etc/containerd/conf.d/99-nvidia.toml \
  || { echo "ERROR: nvidia default runtime missing from drop-in"; exit 1; }
cp /var/lib/rancher/k3s/agent/etc/containerd/config.toml \
   /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
systemctl restart "$UNIT_NAME"
wait_for_ready "$UNIT_NAME" || exit 1

echo "==> kubeconfig for $DEMO_USER"
mkdir -p "$KUBECONFIG_DIR"
cp /etc/rancher/k3s/k3s.yaml "$KUBECONFIG_DIR/config"
chown "${DEMO_UID}:${DEMO_GID}" "$KUBECONFIG_DIR/config"
chmod 600 "$KUBECONFIG_DIR/config"

"$K3S_BIN" kubectl get nodes -o wide
echo "BOOTSTRAP OK"
