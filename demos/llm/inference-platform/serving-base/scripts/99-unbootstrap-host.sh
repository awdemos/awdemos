#!/usr/bin/env bash
# Rollback for 00-bootstrap-host.sh.
#
# All state comes from the manifest bootstrap wrote under $BACKUP_DIR:
#   - files: restore the timestamped backup when the file existed before
#     bootstrap, otherwise remove the file bootstrap created;
#   - subids: remove only the exact lines bootstrap added, so ranges added
#     later for the same user or for other users survive;
#   - systemd unit: use the recorded unit name; save the generated unit on the
#     first attempt and reinstall it on every attempt; validate its [Install]
#     section and all systemd drop-ins before enable/disable so neither a
#     retry nor an operator override can touch unrecorded units or symlinks;
#     restore active state after daemon-reload; keep the state files if
#     enablement or verification fails so the rollback can be retried.
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
# An even older manifest recorded subuid/subgid as whole-file backups; a legacy
# row paired with a restored unit.tsv must not reach the generic restore loop.
if cut -f1 "$MANIFEST" | grep -qE '^(subuid|subgid):'; then
  echo "ERROR: $MANIFEST contains legacy subuid/subgid rows."
  echo "Roll back with the script version that created this manifest first."
  exit 1
fi
# A legacy subids.tsv entry has no exact added line. Refuse before mutating
# anything rather than guessing which ranges to remove.
if [ -f "$SUBIDS" ]; then
  while IFS=$'\t' read -r _file _user _existed added_line; do
    [ -n "$_file" ] || continue
    if [ -z "$added_line" ]; then
      echo "ERROR: $SUBIDS contains an entry without an exact added line (legacy format)."
      echo "Roll back with the script version that created this manifest first."
      exit 1
    fi
  done < "$SUBIDS"
fi

# A non-empty backup path that no longer exists means a pre-existing target
# would be deleted. Refuse instead of failing open.
while IFS=$'\t' read -r label path backup; do
  [ -n "$label" ] || continue
  if [ -n "$backup" ] && [ ! -e "$backup" ]; then
    echo "ERROR: backup for $label is missing: $backup"
    echo "Restore it before rolling back, or remove the stale manifest entry manually."
    exit 1
  fi
done < "$MANIFEST"

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

# Every attempt must apply enablement against the bootstrap-generated unit.
# systemd merges [Install] from drop-ins in every unit path when enable/disable
# runs, so validate the unit and its drop-ins before touching the unit file.
# Do this before stopping the unit so a refusal changes nothing.
[ -n "$_UNIT_PATH" ] || { echo "ERROR: $UNIT_STATE has no unit path; cannot roll back safely."; exit 1; }
UNIT_FILE="$(basename "$_UNIT_PATH")"
GENERATED_UNIT="$BACKUP_DIR/bootstrap-unit.service"

# Fail closed on the [Install] keys systemd actually uses when enabling or
# disabling: Also, Alias, RequiredBy and DefaultInstance must be absent, and
# WantedBy must be exactly multi-user.target. Whitespace around '=' is accepted
# because systemd accepts it; comments, other sections and keys systemd ignores
# are left alone so a harmless override does not block rollback.
install_section_is_generated() {
  awk '
    /^[[:space:]]*[;#]/ { next }
    /^[[:space:]]*\[/ {
      section = $0
      sub(/^[[:space:]]*\[/, "", section)
      sub(/\].*$/, "", section)
      gsub(/[[:space:]]/, "", section)
      next
    }
    section == "Install" && /=/ {
      key = $0
      sub(/[[:space:]]*=.*/, "", key)
      gsub(/[[:space:]]/, "", key)
      value = $0
      sub(/^[^=]*=[[:space:]]*/, "", value)
      gsub(/[[:space:]]/, "", value)
      if (key == "Also" || key == "Alias" || key == "RequiredBy" || key == "DefaultInstance") bad = 1
      if (key == "WantedBy" && value != "multi-user.target") bad = 1
    }
    END { exit bad ? 1 : 0 }
  ' "$1"
}

# Check the unit file and every drop-in for this unit across all systemd unit
# paths. systemd-analyze gives the authoritative list; the static list is the
# same set for hosts without that tool.
check_install_config() {
  local file="$1" p dropin paths
  install_section_is_generated "$file" || return 1
  if command -v systemd-analyze >/dev/null 2>&1; then
    paths="$(systemd-analyze unit-paths 2>/dev/null | grep '^/' || true)"
  else
    paths=""
  fi
  if [ -z "$paths" ]; then
    paths="$(printf '%s\n' \
      /etc/systemd/system.control /run/systemd/system.control \
      /run/systemd/transient /run/systemd/generator.early \
      /etc/systemd/system /etc/systemd/system.attached \
      /run/systemd/system /run/systemd/system.attached \
      /run/systemd/generator /usr/local/lib/systemd/system \
      /usr/lib/systemd/system /run/systemd/generator.late)"
  fi
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    [ -d "$p/$UNIT_FILE.d" ] || continue
    for dropin in "$p/$UNIT_FILE.d"/*.conf; do
      [ -f "$dropin" ] || continue
      install_section_is_generated "$dropin" || return 1
    done
  done <<< "$paths"
}

if [ ! -f "$GENERATED_UNIT" ]; then
  if ! check_install_config "$_UNIT_PATH"; then
    echo "ERROR: no saved bootstrap unit and $_UNIT_PATH or its drop-ins have install directives that could change unrecorded units."
    echo "Restore the bootstrap-generated unit at $_UNIT_PATH (or $GENERATED_UNIT), then retry."
    exit 1
  fi
  mkdir -p "$(dirname "$GENERATED_UNIT")"
  cp -a "$_UNIT_PATH" "$GENERATED_UNIT"
fi
if ! check_install_config "$GENERATED_UNIT"; then
  echo "ERROR: $GENERATED_UNIT or its drop-ins have install directives that could change unrecorded units."
  echo "Restore a copy of the bootstrap-generated unit there, then retry."
  exit 1
fi
cp -a "$GENERATED_UNIT" "$_UNIT_PATH"

echo "==> stop $UNIT_NAME before restoring its unit file"
systemctl stop "$UNIT_NAME" 2>/dev/null || true

state_error=0
case "$WAS_ENABLED" in
  enabled)
    systemctl enable "$UNIT_NAME" 2>/dev/null || state_error=1
    ;;
  enabled-runtime)
    # A persistent symlink from an older bootstrap would keep is-enabled at
    # "enabled"; remove it before restoring the runtime-only enablement.
    systemctl disable "$UNIT_NAME" >/dev/null 2>&1 || true
    systemctl enable --runtime "$UNIT_NAME" 2>/dev/null || state_error=1
    ;;
  *)
    systemctl disable "$UNIT_NAME" >/dev/null 2>&1 || true
    ;;
esac
# Fail before touching any manifest target if enablement could not be
# restored. The generated unit is reinstalled and the unit is stopped; a later
# retry starts from the same known-good unit.
if [ "$state_error" -ne 0 ]; then
  echo "ERROR: could not restore the pre-bootstrap enablement state for $UNIT_NAME."
  echo "The generated unit was reinstalled and $UNIT_NAME was stopped; no manifest targets were restored."
  echo "State files are kept under $BACKUP_DIR for a retry."
  exit 1
fi

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
    # Literal full-line comparison: ENVIRON avoids awk's -v escape decoding.
    ADDED_LINE="$added_line" awk '$0 != ENVIRON["ADDED_LINE"]' "$file" > "$tmp"
    cat "$tmp" > "$file"   # truncate in place to preserve mode and ownership
    rm -f "$tmp"
    if [ ! -s "$file" ] && [ "$existed" = "no" ]; then
      rm -f "$file"
    fi
  done < "$SUBIDS"
fi

echo "==> daemon-reload and reapply active state with the restored unit"
systemctl daemon-reload
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

rm -f "$MANIFEST" "$SUBIDS" "$UNIT_STATE" "$GENERATED_UNIT"

echo "BOOTSTRAP ROLLED BACK"
echo "Note: registry image data and /var/lib/rancher/k3s are intentionally left in place."
