#!/usr/bin/env bash

set -euo pipefail

STORE_ROOT="${STORE_ROOT:-/mnt/BigData}"

usage() {
  cat <<'EOF'
Usage:
  scripts/copy-to-bigdata-store.sh <installable> [<installable> ...]

Examples:
  scripts/copy-to-bigdata-store.sh .#packages.x86_64-linux.hello
  scripts/copy-to-bigdata-store.sh .#nixosConfigurations.homelab.config.system.build.toplevel
  STORE_ROOT=/mnt/OtherPool scripts/copy-to-bigdata-store.sh .#checks.x86_64-linux.some-check

Notes:
  - The target must be the parent of the alternative nix store.
  - With the current homelab setup this is /mnt/BigData, which contains /mnt/BigData/nix/store.
  - The script runs 'sudo nix copy --to <store-root> ...' and copies full closures.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$#" -lt 1 ]]; then
  usage >&2
  exit 1
fi

if [[ ! -d "$STORE_ROOT" ]]; then
  echo "Target store root does not exist: $STORE_ROOT" >&2
  exit 1
fi

exec sudo nix copy --to "$STORE_ROOT" "$@"
