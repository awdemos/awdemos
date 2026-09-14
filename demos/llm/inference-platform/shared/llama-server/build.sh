#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORK_COMMIT="$(tr -d '[:space:]' < "$DIR/FORK_COMMIT")"
[ -n "$FORK_COMMIT" ] || { echo "FORK_COMMIT is empty" >&2; exit 1; }
TAG="localhost:5000/llama-server:${FORK_COMMIT:0:7}"
podman build --build-arg "FORK_COMMIT=$FORK_COMMIT" -t "$TAG" "$DIR"
podman run --rm "$TAG" --help >/dev/null
podman push --tls-verify=false "$TAG"
echo "pushed $TAG"
