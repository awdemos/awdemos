#!/usr/bin/env bash
# Rollback for 00-bootstrap-host.sh.
#
# All state comes from the manifest bootstrap wrote under $BACKUP_DIR:
#   - files: restore the timestamped backup when the file existed before
#     bootstrap, otherwise remove the file bootstrap created;
#   - subids: surgically remove only the user's ranges that bootstrap added,
#     preserving ranges added by other users in the meantime;
#   - systemd unit: use the recorded unit name, restore the recorded
#     enabled/active state after restoring files and reloading systemd.
#
# Deliberately NOT removed: downloaded binaries in the user's home, registry
# image data, and k3s state under /var/lib/rancher/k3s.
#
# Run as root. No overrides are needed except BACKUP_DIR if it was overridden
# at bootstrap:
#
#   sudo bash 99-unbootstrap-host.sh
#   sudo BACKUP_DIR=/custom/backup/dir bash 99-unbootstrap-host.sh
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

BACKUP_DIR="${BACKUP_DIR:-/var/lib/inference-platform-bootstrap-backup}"
MANIFEST="$BACKUP_DIR/manifest.tsv"
SUBIDS="$BACKUP_DIR/subids.tsv"
UNIT_STATE="$BACKUP_DIR/unit.tsv"

if [ ! -f "$MANIFEST" ]; then
  echo "No bootstrap state found at $MANIFEST; nothing to roll back."
  exit 0
fi

# Derive unit identity and prior state from the manifest, never from the
# current environment: a bootstrap with a custom K3S_UNIT must still be
# stopped and restored correctly.
UNIT_NAME=""
WAS_ENABLED=""
WAS_ACTIVE=""
if [ -f "$UNIT_STATE" ]; then
  IFS=$'\t' read -r UNIT_NAME _UNIT_PATH WAS_ENABLED WAS_ACTIVE < "$UNIT_STATE" || true
fi
[ -n "$UNIT_NAME" ] || UNIT_NAME="k3s"

echo "==> Planned rollback from $MANIFEST"
echo "    stop current unit: $(basename "$UNIT_NAME" .service)"
echo "    unit state before bootstrap: enabled=$WAS_ENABLED active=$WAS_ACTIVE"
echo "    restore or remove every target recorded in the manifest"
echo "    remove only the recorded subuid/subgid ranges"
echo "    leave in place:    registry data, k3s state, downloaded home binaries"
echo
read -r -p "Type 'yes' to continue: " confirm
[ "$confirm" = "yes" ] || { echo "Aborted"; exit 1; }

echo "==> stop $UNIT_NAME before restoring its unit file"
systemctl stop "$UNIT_NAME" 2>/dev/null || true

echo "==> restore pre-existing files and remove bootstrap-created ones"
while IFS=$'\t' read -r label path backup; do
  [ -n "$label" ] || continue
  if [ -n "$backup" ] && [ -e "$backup" ]; then
    mkdir -p "$(dirname "$path")"
    cp -a "$backup" "$path"
  else
    rm -f "$path"
  fi
done < "$MANIFEST"

echo "==> remove only the subuid/subgid ranges bootstrap added"
if [ -f "$SUBIDS" ]; then
  while IFS=$'\t' read -r file user existed; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue
    tmp="$(mktemp)"
    # Literal first-field comparison; no regex interpolation of the username.
    awk -F: -v u="$user" '$1 != u' "$file" > "$tmp"
    cat "$tmp" > "$file"   # truncate in place to preserve mode and ownership
    rm -f "$tmp"
    if [ ! -s "$file" ] && [ "$existed" = "no" ]; then
      rm -f "$file"
    fi
  done < "$SUBIDS"
fi

echo "==> daemon-reload and restore unit state"
systemctl daemon-reload
case "$WAS_ENABLED" in
  enabled|enabled-runtime) systemctl enable "$UNIT_NAME" 2>/dev/null || true ;;
  *)                       systemctl disable "$UNIT_NAME" 2>/dev/null || true ;;
esac
if [ "$WAS_ACTIVE" = "active" ]; then
  systemctl start "$UNIT_NAME" 2>/dev/null || true
fi

rm -f "$MANIFEST" "$SUBIDS" "$UNIT_STATE"

echo "BOOTSTRAP ROLLED BACK"
echo "Note: registry image data and /var/lib/rancher/k3s are intentionally left in place."
