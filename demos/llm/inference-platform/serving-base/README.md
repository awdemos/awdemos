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

Before changing any target, bootstrap writes a manifest to `$BACKUP_DIR/manifest.tsv`
and copies pre-existing targets to timestamped backups there. A second bootstrap
run is refused while that manifest exists, so state cannot compound.

`scripts/99-unbootstrap-host.sh` consumes the manifest:

```bash
sudo bash scripts/99-unbootstrap-host.sh
# or, with overrides:
sudo DEMO_USER=alice bash scripts/99-unbootstrap-host.sh
```

It prompts for confirmation, stops and disables the k3s unit, then walks the
manifest and **restores the backup** for every target that existed before
bootstrap, or **removes the target** when bootstrap created it. Managed targets
include the installed k3s binary, the systemd unit, `registries.yaml`, the
copied kubeconfig, the containerd config/drop-in/template changed by
`nvidia-ctk`, and the user's subuid/subgid lines. It then reloads systemd and
deletes the manifest. With no manifest it exits without changing anything.

It intentionally leaves in place: downloaded binaries in the user's home (not
created by this script), registry image data in `$REGISTRY_DIR`, and k3s cluster
state under `/var/lib/rancher/k3s`. Remove those manually only after confirming
nothing else depends on them.
