#!/usr/bin/env bash
# Rollback for 00-bootstrap-host.sh.
#
# All state comes from the manifest bootstrap wrote under $BACKUP_DIR:
#   - files: restore the timestamped backup when the file existed before
#     bootstrap, otherwise remove the file bootstrap created;
#   - subids: remove only the exact lines bootstrap added, so ranges added
#     later for the same user or for other users survive;
#   - systemd unit: use the recorded unit name, restore the recorded
#     enabled/active state after restoring files and reloading systemd, and
#     keep the state files if verification fails so the rollback can be retried.
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

# Fail closed rather than guess when state is incomplete or from an older
# format. A legacy subuid/subgid row points at a whole-file snapshot; restoring
# it would erase ranges added by other users since bootstrap.
if [ ! -f "$UNIT_STATE" ]; then
  echo "ERROR: $UNIT_STATE is missing; cannot roll back safely."
  echo "Roll back with the script version that created this manifest, or restore $UNIT_STATE."
  exit 1
fi
if cut -f1 "$MANIFEST" | grep -qE '^(subuid|subgid):'; then
  echo "ERROR: $MANIFEST contains legacy subuid/subgid rows."
  echo "Roll back with the script version that created this manifest first."
  exit 1
fi

# Derive unit identity and prior state from the manifest, never from the
# current environment: a bootstrap with a custom K3S_UNIT must still be
# stopped and restored correctly.
UNIT_NAME=""
WAS_ENABLED=""
WAS_ACTIVE=""
IFS=$'\t' read -r UNIT_NAME _UNIT_PATH WAS_ENABLED WAS_ACTIVE < "$UNIT_STATE" || true
if [ -z "$UNIT_NAME" ]; then
  echo "ERROR: $UNIT_STATE does not contain a unit name; cannot roll back safely."
  exit 1
fi

echo "==> Planned rollback from $MANIFEST"
echo "    stop current unit: $(basename "$UNIT_NAME" .service)"
echo "    unit state before bootstrap: enabled=$WAS_ENABLED active=$WAS_ACTIVE"
echo "    restore or remove every target recorded in the manifest"
echo "    remove only the exact subuid/subgid lines bootstrap added"
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

echo "==> remove only the exact subuid/subgid lines bootstrap added"
if [ -f "$SUBIDS" ]; then
  while IFS=$'\t' read -r file _user existed added_line; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue
    if [ -z "$added_line" ]; then
      echo "ERROR: incomplete entry in $SUBIDS; refusing to remove ranges by user name."
      echo "Remove the added line manually, then delete this entry and re-run rollback."
      exit 1
    fi
    tmp="$(mktemp)"
    # Literal full-line comparison: exact line only, never a user-name regex.
    awk -v line="$added_line" '$0 != line' "$file" > "$tmp"
    cat "$tmp" > "$file"   # truncate in place to preserve mode and ownership
    rm -f "$tmp"
    if [ ! -s "$file" ] && [ "$existed" = "no" ]; then
      rm -f "$file"
    fi
  done < "$SUBIDS"
fi

echo "==> daemon-reload and restore unit state"
systemctl daemon-reload

state_error=0
case "$WAS_ENABLED" in
  enabled)
    systemctl enable "$UNIT_NAME" 2>/dev/null || state_error=1
    ;;
  enabled-runtime)
    systemctl enable --runtime "$UNIT_NAME" 2>/dev/null || state_error=1
    ;;
  *)
    systemctl disable "$UNIT_NAME" >/dev/null 2>&1 || true
    ;;
esac
if [ "$WAS_ACTIVE" = "active" ]; then
  systemctl start "$UNIT_NAME" 2>/dev/null || state_error=1
fi

# Verify the restored state instead of assuming the commands succeeded. On any
# mismatch, keep the manifests so the operator can retry after fixing the cause.
now_enabled="$(systemctl is-enabled "$UNIT_NAME" 2>/dev/null || true)"
case "$WAS_ENABLED" in
  enabled|enabled-runtime)
    if [ "$now_enabled" != "$WAS_ENABLED" ]; then
      state_error=1
    fi
    ;;
  *)
    case "$now_enabled" in
      enabled|enabled-runtime) state_error=1 ;;
    esac
    ;;
esac

now_active="$(systemctl is-active "$UNIT_NAME" 2>/dev/null || true)"
if [ "$WAS_ACTIVE" = "active" ]; then
  if [ "$now_active" != "active" ]; then
    state_error=1
  fi
else
  if [ "$now_active" = "active" ]; then
    state_error=1
  fi
fi

if [ "$state_error" -ne 0 ]; then
  echo "ERROR: could not restore the pre-bootstrap unit state for $UNIT_NAME."
  echo "Files were restored, but state files are kept under $BACKUP_DIR for a retry."
  exit 1
fi

rm -f "$MANIFEST" "$SUBIDS" "$UNIT_STATE"

echo "BOOTSTRAP ROLLED BACK"
echo "Note: registry image data and /var/lib/rancher/k3s are intentionally left in place."
