#!/usr/bin/env bash
# One-time host bootstrap for the D1 serving-base demo.
#
# MANUAL GATE: this script changes host-level state (systemd, /etc, registry
# storage, subuid/subgid, containerd). Review it before running. Run as root:
#
#   sudo bash 00-bootstrap-host.sh
#
# All host-specific paths and the account name are parameters. Defaults match
# the original single-user demo box; override them via the environment. sudo
# strips most variables, so pass overrides explicitly, for example:
#
#   sudo DEMO_USER=alice K3S_SRC=/home/alice/bin/k3s bash 00-bootstrap-host.sh
#
# Every file this script replaces or creates is recorded in a manifest with a
# timestamped backup. The pre-bootstrap systemd state and the exact subuid/
# subgid lines added are recorded too. 99-unbootstrap-host.sh restores all of
# it with no overrides required.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo"; exit 1; }

# ── Parameters ─────────────────────────────────────────────────────────────────
DEMO_USER="${DEMO_USER:-${SUDO_USER:-a}}"
id "$DEMO_USER" >/dev/null 2>&1 || { echo "ERROR: no such user: $DEMO_USER"; exit 1; }

DEMO_UID="$(id -u "$DEMO_USER")"
DEMO_GID="$(id -g "$DEMO_USER")"
DEMO_HOME="${DEMO_HOME:-$(getent passwd "$DEMO_USER" | cut -d: -f6 || true)}"
[ -n "$DEMO_HOME" ] || { echo "ERROR: cannot determine home for $DEMO_USER"; exit 1; }

K3S_SRC="${K3S_SRC:-$DEMO_HOME/.local/bin/k3s}"
CTK_BIN="${CTK_BIN:-$DEMO_HOME/.local/bin/nvidia-ctk}"
K3S_BIN="${K3S_BIN:-/usr/local/bin/k3s}"
REGISTRY_DIR="${REGISTRY_DIR:-/var/lib/inference-registry}"
K3S_CONFIG_DIR="${K3S_CONFIG_DIR:-/etc/rancher/k3s}"
K3S_UNIT="${K3S_UNIT:-/etc/systemd/system/k3s.service}"
KUBECONFIG_DIR="${KUBECONFIG_DIR:-$DEMO_HOME/.kube}"
BACKUP_DIR="${BACKUP_DIR:-/var/lib/inference-platform-bootstrap-backup}"
MANIFEST="$BACKUP_DIR/manifest.tsv"
SUBIDS="$BACKUP_DIR/subids.tsv"
UNIT_STATE="$BACKUP_DIR/unit.tsv"

CONTAINERD_CONFIG=/var/lib/rancher/k3s/agent/etc/containerd/config.toml
CONTAINERD_TMPL=/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
NVIDIA_DROPIN=/etc/containerd/conf.d/99-nvidia.toml

for required in "$K3S_SRC" "$CTK_BIN"; do
  [ -x "$required" ] || { echo "ERROR: missing or non-executable: $required"; exit 1; }
done

if [ -e "$MANIFEST" ]; then
  echo "ERROR: bootstrap state already exists at $MANIFEST."
  echo "Run 99-unbootstrap-host.sh before bootstrapping again."
  exit 1
fi

# A unit symlink would be followed by `cat >`, overwriting the package-provided
# target while the rollback only restores the symlink. Refuse it explicitly.
if [ -L "$K3S_UNIT" ]; then
  echo "ERROR: $K3S_UNIT is a symlink; bootstrap requires a regular file."
  echo "Point K3S_UNIT at the real unit file before bootstrapping."
  exit 1
fi

UNIT_NAME="$(basename "$K3S_UNIT" .service)"

echo "==> Configuration"
echo "    user=$DEMO_USER uid=$DEMO_UID gid=$DEMO_GID home=$DEMO_HOME"
echo "    k3s source=$K3S_SRC -> $K3S_BIN"
echo "    nvidia-ctk=$CTK_BIN"
echo "    registry=$REGISTRY_DIR"
echo "    k3s config=$K3S_CONFIG_DIR"
echo "    systemd unit=$K3S_UNIT ($UNIT_NAME)"
echo "    kubeconfig=$KUBECONFIG_DIR/config"
echo "    backup/manifest=$BACKUP_DIR / $MANIFEST"

mkdir -p "$BACKUP_DIR"
: > "$MANIFEST"
: > "$SUBIDS"
: > "$UNIT_STATE"

# Capture the pre-bootstrap unit state BEFORE the unit file is replaced or
# `enable --now` runs, so rollback can restore enabled/active independently.
WAS_ENABLED="$(systemctl is-enabled "$UNIT_NAME" 2>/dev/null || true)"
WAS_ACTIVE="$(systemctl is-active "$UNIT_NAME" 2>/dev/null || true)"
printf '%s\t%s\t%s\t%s\n' "$UNIT_NAME" "$K3S_UNIT" "$WAS_ENABLED" "$WAS_ACTIVE" > "$UNIT_STATE"

# Record a target before modifying it. An empty backup field means the file did
# not exist before bootstrap and should be removed on rollback.
record_target() {
  local label="$1" path="$2" backup=""
  if [ -e "$path" ]; then
    backup="$BACKUP_DIR/$label.$(date +%Y%m%d%H%M%S)"
    cp -a "$path" "$backup"
  fi
  printf '%s\t%s\t%s\n' "$label" "$path" "$backup" >> "$MANIFEST"
}

# Literal first-field match: a dotted username such as a.b must not match axb.
user_has_range() {
  local file="$1" user="$2"
  [ -f "$file" ] || return 1
  awk -F: -v u="$user" '$1 == u { found = 1 } END { exit !found }' "$file"
}

# Only touch subuid/subgid when this user has no range. Record the exact lines
# usermod adds, not just the user name: another admin may add more ranges for
# the same user after bootstrap, and rollback must leave those intact. The
# timestamped full-file copy is a safety artifact, never restored automatically.
add_subid_range() {
  local file="$1" label="$2" flag="$3" existed="no" before added line
  user_has_range "$file" "$DEMO_USER" && return 0

  [ -e "$file" ] && existed="yes"
  before="$BACKUP_DIR/$label.$(date +%Y%m%d%H%M%S).safety"
  if [ -e "$file" ]; then
    cp -a "$file" "$before"
  else
    : > "$before"
  fi

  if [ "$flag" = subuid ]; then
    usermod --add-subuids 100000-165535 "$DEMO_USER"
  else
    usermod --add-subgids 100000-165535 "$DEMO_USER"
  fi

  added="$(grep -Fxv -f "$before" "$file" | awk -F: -v u="$DEMO_USER" '$1 == u' || true)"
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    printf '%s\t%s\t%s\t%s\n' "$file" "$DEMO_USER" "$existed" "$line" >> "$SUBIDS"
  done <<< "$added"
}

# ── Install ────────────────────────────────────────────────────────────────────
echo "==> install k3s binary (SELinux: init cannot exec from home)"
record_target k3s-bin "$K3S_BIN"
install -m 0755 "$K3S_SRC" "$K3S_BIN"

echo "==> subuid/subgid for rootless podman ($DEMO_USER)"
add_subid_range /etc/subuid subuid subuid
add_subid_range /etc/subgid subgid subgid

echo "==> local registry storage"
mkdir -p "$REGISTRY_DIR" && chown "${DEMO_UID}:${DEMO_GID}" "$REGISTRY_DIR"

echo "==> k3s systemd unit"
record_target k3s-unit "$K3S_UNIT"
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
record_target registries "$K3S_CONFIG_DIR/registries.yaml"
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

systemctl daemon-reload
systemctl enable --now "$UNIT_NAME"
wait_for_ready "$UNIT_NAME" || exit 1
echo "==> k3s up"

echo "==> nvidia containerd runtime (drop-in + config.toml.tmpl)"
record_target containerd-config "$CONTAINERD_CONFIG"
record_target containerd-dropin "$NVIDIA_DROPIN"
record_target containerd-tmpl "$CONTAINERD_TMPL"
"$CTK_BIN" runtime configure --runtime=containerd --set-as-default=true \
  --config="$CONTAINERD_CONFIG" \
  || { echo "ERROR: nvidia-ctk runtime configure failed"; exit 1; }
grep -qE '^\s*default_runtime_name\s*=\s*"nvidia"' "$NVIDIA_DROPIN" \
  || { echo "ERROR: nvidia default runtime missing from drop-in"; exit 1; }
cp "$CONTAINERD_CONFIG" "$CONTAINERD_TMPL"
systemctl restart "$UNIT_NAME"
wait_for_ready "$UNIT_NAME" || exit 1

echo "==> kubeconfig for $DEMO_USER"
record_target kubeconfig "$KUBECONFIG_DIR/config"
mkdir -p "$KUBECONFIG_DIR"
cp /etc/rancher/k3s/k3s.yaml "$KUBECONFIG_DIR/config"
chown "${DEMO_UID}:${DEMO_GID}" "$KUBECONFIG_DIR/config"
chmod 600 "$KUBECONFIG_DIR/config"

"$K3S_BIN" kubectl get nodes -o wide
echo "BOOTSTRAP OK"
echo "Pre-existing targets were backed up under $BACKUP_DIR; 99-unbootstrap-host.sh restores them."
