# D1: serving-base

Single-node llama-server demo on one 16 GB GPU. This directory currently holds
the host bootstrap required to get k3s and the NVIDIA containerd runtime onto a
dedicated demo box. The full D1 harness is still in progress; see the
[platform README](../README.md) for status.

## Bootstrap

`scripts/00-bootstrap-host.sh` changes host-level state. It is a manual gate,
not something to run from CI or a shell you have not reviewed.

```bash
cd demos/llm/inference-platform/serving-base
sudo bash scripts/00-bootstrap-host.sh
```

The script installs the k3s binary to `/usr/local/bin`, adds subuid/subgid ranges
for the demo user, creates localhost registry storage, writes a k3s systemd unit
and a localhost-only `registries.yaml`, configures the NVIDIA containerd runtime,
waits for the node to become Ready, and copies the kubeconfig to the user's
`$HOME/.kube/config`.

### Parameters

Nothing about the demo host is hardcoded to a particular account. Override any
of these environment variables. Because `sudo` strips most variables, pass them
on the `sudo` command line:

| Variable | Default | Purpose |
|---|---|---|
| `DEMO_USER` | `$SUDO_USER`, else `a` | Account that owns the kubeconfig and subuid/subgid ranges |
| `DEMO_HOME` | that user's passwd home | Home directory used for kubeconfig |
| `K3S_SRC` | `$DEMO_HOME/.local/bin/k3s` | Source k3s binary |
| `CTK_BIN` | `$DEMO_HOME/.local/bin/nvidia-ctk` | `nvidia-ctk` binary |
| `K3S_BIN` | `/usr/local/bin/k3s` | Installed k3s binary |
| `REGISTRY_DIR` | `/var/lib/inference-registry` | Local registry storage |
| `K3S_CONFIG_DIR` | `/etc/rancher/k3s` | k3s config directory |
| `K3S_UNIT` | `/etc/systemd/system/k3s.service` | systemd unit path |
| `KUBECONFIG_DIR` | `$DEMO_HOME/.kube` | Destination for the kubeconfig |
| `BACKUP_DIR` | `/var/lib/inference-platform-bootstrap-backup` | Timestamped backups and the rollback manifest |

Example for another account:

```bash
sudo DEMO_USER=alice K3S_SRC=/home/alice/bin/k3s bash scripts/00-bootstrap-host.sh
```

The script prints the resolved configuration and validates that the source
binaries are executable before changing anything. The registry mirror is
intentionally insecure (`http://localhost:5000`) for this single-user demo box;
do not reuse it on a shared or internet-facing host.

## Rollback

Before changing any target, bootstrap writes three files under `$BACKUP_DIR`:

| File | Contents |
| --- | --- |
| `manifest.tsv` | File targets, each with a timestamped backup when it already existed |
| `subids.tsv` | The exact `/etc/subuid` / `/etc/subgid` lines bootstrap added, with the file, user, and whether the file existed before |
| `unit.tsv` | The systemd unit name/path and whether it was enabled/active before bootstrap |

A second bootstrap run is refused while `manifest.tsv` exists, so state cannot
compound.

`scripts/99-unbootstrap-host.sh` reads those files:

```bash
sudo bash scripts/99-unbootstrap-host.sh
# if BACKUP_DIR was overridden at bootstrap:
sudo BACKUP_DIR=/custom/backup/dir bash scripts/99-unbootstrap-host.sh
```

No other overrides are needed; the unit identity, prior unit state, and exact
subid changes all come from the manifest, so a bootstrap with a custom
`K3S_UNIT` or `DEMO_USER` rolls back correctly with the plain command above.

It prompts for confirmation, stops the current unit, then walks `manifest.tsv`
and **restores the backup** for every target that existed before bootstrap, or
**removes the target** when bootstrap created it. Managed targets include the
installed k3s binary, the systemd unit, `registries.yaml`, the copied
kubeconfig, and the containerd config/drop-in/template changed by `nvidia-ctk`.
It removes only the exact recorded lines from `/etc/subuid` and `/etc/subgid`,
so ranges added later for the same user or for other users survive. It saves a
copy of bootstrap's generated unit on the first rollback and reinstalls it at
the start of every attempt, and validates its `[Install]` section and every
systemd drop-in for the unit before calling `enable`/`disable`. That keeps the
operation to the generated `WantedBy=multi-user.target` link, so neither a
retry nor an operator drop-in can change companion units, aliases, or targets
that were never recorded. It then restores the recorded enablement (including
`enabled-runtime`), restores the files, reloads systemd, reapplies the recorded
active state, and verifies both with `is-enabled`/`is-active`. If enablement
fails it stops before restoring any manifest target, leaving the generated unit
reinstalled and the unit stopped; if final verification fails it leaves the
files restored. Both failures **keep the state files** so the rollback can be
retried; only a verified rollback deletes the manifest files and the saved
generated unit. With no manifest it exits without changing anything.

Rollback refuses incomplete state rather than guessing, before changing
anything: missing `unit.tsv`; legacy `subuid:*` / `subgid:*` rows in
`manifest.tsv` or a `subids.tsv` entry without an exact added line (both from
older script versions); a backup path recorded in the manifest that no longer
exists; or effective `[Install]` directives in the recorded unit or any systemd
drop-in for it that could create unrecorded units or symlinks (`Also=`, `Alias=`,
`RequiredBy=`, `DefaultInstance=`, or a `WantedBy=` other than
`multi-user.target`). Keys systemd ignores do not block rollback. `K3S_UNIT`
must be a regular file at bootstrap; a symlinked unit path is rejected because
`cat >` would overwrite the symlink target. Bootstrap also preserves
runtime-only enablement instead of promoting it to a persistent systemd unit.

It intentionally leaves in place: downloaded binaries in the user's home (not
created by this script), registry image data, and k3s cluster state under
`/var/lib/rancher/k3s`. Remove those manually only after confirming nothing
else depends on them.
