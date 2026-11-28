#!/usr/bin/env bash
# Rollback for 00-bootstrap-host.sh.
#
# Removes the host-level files that bootstrap created. It deliberately does NOT
# remove: downloaded binaries in the user's home, subuid/subgid ranges (they are
# shared with rootless podman), registry image data, or k3s state under
# /var/lib/rancher/k3s. Delete those only after checking nothing else uses them.
#
# Run as root with the same parameters used for bootstrap:
#
#   sudo bash 99-unbootstrap-host.sh
#   sudo DEMO_USER=alice K3S_SRC=/home/alice/bin/k3s bash 99-unbootstrap-host.sh
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

DEMO_USER="${DEMO_USER:-${SUDO_USER:-a}}"
id "$DEMO_USER" >/dev/null 2>&1 || echo "WARNING: no such user: $DEMO_USER (continuing)"
DEMO_HOME="$(getent passwd "$DEMO_USER" 2>/dev/null | cut -d: -f6 || true)"

K3S_BIN="${K3S_BIN:-/usr/local/bin/k3s}"
REGISTRY_DIR="${REGISTRY_DIR:-/var/lib/inference-registry}"
K3S_CONFIG_DIR="${K3S_CONFIG_DIR:-/etc/rancher/k3s}"
K3S_UNIT="${K3S_UNIT:-/etc/systemd/system/k3s.service}"
KUBECONFIG_DIR="${KUBECONFIG_DIR:-${DEMO_HOME:-/var/home/$DEMO_USER}/.kube}"

echo "==> Planned rollback"
echo "    stop/disable unit: $K3S_UNIT"
echo "    remove unit:       $K3S_UNIT"
echo "    remove config:     $K3S_CONFIG_DIR/registries.yaml"
echo "    remove binary:     $K3S_BIN"
echo "    remove kubeconfig: $KUBECONFIG_DIR/config"
echo "    leave in place:    registry data, k3s state, subuid/subgid, home binaries"
echo
read -r -p "Type 'yes' to continue: " confirm
[ "$confirm" = "yes" ] || { echo "Aborted"; exit 1; }

UNIT_NAME="$(basename "$K3S_UNIT" .service)"

if [ -f "$K3S_UNIT" ]; then
  echo "==> stop and disable $UNIT_NAME"
  systemctl stop "$UNIT_NAME" 2>/dev/null || true
  systemctl disable "$UNIT_NAME" 2>/dev/null || true
fi

echo "==> remove files created by bootstrap"
rm -f "$K3S_UNIT"
rm -f "$K3S_CONFIG_DIR/registries.yaml"
rmdir "$K3S_CONFIG_DIR" 2>/dev/null || true
rm -f "$K3S_BIN"
rm -f "$KUBECONFIG_DIR/config"
rmdir "$KUBECONFIG_DIR" 2>/dev/null || true

echo "==> daemon-reload"
systemctl daemon-reload

echo "BOOTSTRAP ROLLED BACK"
echo "Note: $REGISTRY_DIR and /var/lib/rancher/k3s are intentionally left in place."
