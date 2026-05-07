#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if [ $# -lt 1 ]; then
  printf 'Usage: %s "keyword"\n' "$0" >&2
  exit 1
fi

query="$*"

if command -v rg >/dev/null 2>&1; then
  SEARCH_CMD=(rg -n --color never --max-count 5 "$query")
else
  SEARCH_CMD=(grep -R -n -m 5 "$query")
fi

run_search() {
  local label="$1"
  local dir="$2"

  printf '\n## %s\n' "$label"

  if [ ! -d "$dir" ]; then
    printf '(missing) %s\n' "$dir"
    return
  fi

  if ! "${SEARCH_CMD[@]}" "$dir" 2>/dev/null; then
    printf '(no hits)\n'
  fi
}

# OPC System
run_search "选题记录" "$OPC_ROOT/04.选题决策/选题管理/选题研究"
run_search "待发布的选题" "$OPC_ROOT/04.选题决策/选题管理/待发布的选题"
run_search "已发布的选题" "$OPC_ROOT/07.发布存档/已发布的选题"
run_search "经验沉淀" "$OPC_ROOT/09.经验沉淀"
run_search "数据反馈" "$OPC_ROOT/08.数据反馈"
run_search "对标账号" "$OPC_ROOT/02.对标账号"

# 知识库
run_search "知识库" "$KNOWLEDGE_DIR"

# 风格参考
run_search "风格参考" "$STYLE_DIR"
