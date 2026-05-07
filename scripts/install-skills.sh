#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

target_dir="${1:-${HOME}/.codex/skills}"

mkdir -p "$target_dir"

for skill in jacky-opc jacky-hook jacky-illustration jacky-de-ai jacky-xhs-check; do
  cp -R "$REPO_ROOT/skills/$skill" "$target_dir/"
  printf 'installed %s -> %s\n' "$skill" "$target_dir"
done

