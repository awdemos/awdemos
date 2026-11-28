#!/usr/bin/env bash
# Rollback for 00-bootstrap-host.sh.
#
# Reads the manifest written by bootstrap and, for each recorded target:
#   - restores the timestamped backup when the file existed before bootstrap;
#   - removes the file when bootstrap created it;
#   - removes only this user's subuid/subgid lines when those files did not
#     exist before bootstrap.
#
# Deliberately NOT removed: downloaded binaries in the user's home, registry
# image data in $REGISTRY_DIR, and k3s state under /var/lib/rancher/k3s.
#
# Run as root with the same parameters used for bootstrap:
#
#   sudo bash 99-unbootstrap-host.sh
#   sudo DEMO_USER=alice bash 99-unbootstrap-host.sh
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

DEMO_USER="${DEMO_USER:-${SUDO_USER:-a}}"
K3S_UNIT="${K3S_UNIT:-/etc/systemd/system/k3s.service}"
BACKUP_DIR="${BACKUP_DIR:-/var/lib/inference-platform-bootstrap-backup}"
MANIFEST="$BACKUP_DIR/manifest.tsv"
REGISTRY_DIR="${REGISTRY_DIR:-/var/lib/inference-registry}"

if [ ! -f "$MANIFEST" ]; then
  echo "No bootstrap state found at $MANIFEST; nothing to roll back."
  exit 0
fi

echo "==> Planned rollback from $MANIFEST"
echo "    stop/disable unit: $(basename "$K3S_UNIT" .service)"
echo "    restore or remove every target recorded in the manifest"
echo "    leave in place:    registry data, k3s state, downloaded home binaries"
echo
read -r -p "Type 'yes' to continue: " confirm
[ "$confirm" = "yes" ] || { echo "Aborted"; exit 1; }

UNIT_NAME="$(basename "$K3S_UNIT" .service)"
if [ -f "$K3S_UNIT" ]; then
  echo "==> stop and disable $UNIT_NAME"
  systemctl stop "$UNIT_NAME" 2>/dev/null || true
  systemctl disable "$UNIT_NAME" 2>/dev/null || true
fi

echo "==> restore pre-existing files and remove bootstrap-created ones"
while IFS=$'\t' read -r label path backup; do
  [ -n "$label" ] || continue

  case "$label" in
    subuid:*|subgid:*)
      user="${label#*:}"
      if [ -n "$backup" ] && [ -e "$backup" ]; then
        cp -a "$backup" "$path"
      elif [ -f "$path" ]; then
        # No pre-existing file: drop only the range bootstrap added for this user.
        sed -i "/^${user}:/d" "$path"
      fi
      ;;
    *)
      if [ -n "$backup" ] && [ -e "$backup" ]; then
        mkdir -p "$(dirname "$path")"
        cp -a "$backup" "$path"
      else
        rm -f "$path"
      fi
      ;;
  esac
done < "$MANIFEST"

rm -f "$MANIFEST"

echo "==> daemon-reload"
systemctl daemon-reload

echo "BOOTSTRAP ROLLED BACK"
echo "Note: $REGISTRY_DIR and /var/lib/rancher/k3s are intentionally left in place."
