#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

ensure_managed_paths

if [ $# -lt 2 ]; then
  printf 'Usage: %s <short-video|longform|xiaohongshu|post|research> "title"\n' "$0" >&2
  exit 1
fi

type="$1"
title="$2"

target="$(target_path_for_type_title "$type" "$title")"
template="$(template_for_type "$type")"

mkdir -p "$(dirname "$target")"

if [ -f "$target" ]; then
  printf '%s\n' "$target"
  exit 0
fi

case "$type" in
  research)
    render_template "$template" "$target" "$title" "$(human_date)" "research" "research"
    ;;
  short-video|longform|xiaohongshu|post)
    render_template "$template" "$target" "$title" "$(human_date)" "$type" "待发布"
    ;;
  *)
    printf 'Unknown type: %s\n' "$type" >&2
    exit 1
    ;;
esac

printf '%s\n' "$target"
