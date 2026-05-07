#!/usr/bin/env bash

set -euo pipefail

repo_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "$script_dir/.." && pwd
}

load_env_file() {
  local root
  root="$(repo_root)"

  if [ -f "$root/.env" ]; then
    set -a
    # shellcheck disable=SC1091
    . "$root/.env"
    set +a
  fi
}

require_opc_root() {
  load_env_file

  if [ -z "${OPC_ROOT:-}" ]; then
    printf 'Missing OPC_ROOT. Set it in .env or pass it inline:\n' >&2
    printf '  OPC_ROOT="$HOME/Documents/OPC-System" %s\n' "$0" >&2
    exit 1
  fi
}

dot_date() {
  date +%Y.%m.%d
}

compact_date() {
  date +%Y%m%d
}

human_date() {
  date +%Y-%m-%d
}

safe_title() {
  printf '%s' "$1" | tr '/:' '--' | sed 's/[[:space:]]\+$//'
}

knowledge_dir() {
  if [ -n "${KNOWLEDGE_DIR:-}" ]; then
    printf '%s\n' "$KNOWLEDGE_DIR"
  else
    printf '%s\n' "$OPC_ROOT/00.知识库"
  fi
}

template_dir() {
  printf '%s/templates\n' "$(repo_root)"
}

ensure_managed_paths() {
  mkdir -p \
    "$OPC_ROOT/04.选题决策/选题管理/选题研究" \
    "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/短视频" \
    "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/公众号+小红书长文" \
    "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/推文库" \
    "$OPC_ROOT/07.发布存档/已发布的选题/短视频" \
    "$OPC_ROOT/07.发布存档/已发布的选题/公众号+小红书长文" \
    "$OPC_ROOT/08.数据反馈/月度数据分析报告" \
    "$(knowledge_dir)"

  if [ ! -f "$OPC_ROOT/04.选题决策/选题管理/选题研究/00-选题记录.md" ]; then
    printf '# 00-选题记录\n\n这个文件用于承接还没进入正式写作的灵感、问题、评论反馈和 brief。\n' \
      >"$OPC_ROOT/04.选题决策/选题管理/选题研究/00-选题记录.md"
  fi
}

route_dir() {
  case "$1" in
    short-video) printf '%s\n' "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/短视频" ;;
    longform|xiaohongshu) printf '%s\n' "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/公众号+小红书长文" ;;
    post) printf '%s\n' "$OPC_ROOT/04.选题决策/选题管理/待发布的选题/推文库" ;;
    research) printf '%s\n' "$OPC_ROOT/04.选题决策/选题管理/选题研究" ;;
    *)
      printf 'Unknown type: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

template_for_type() {
  case "$1" in
    short-video) printf '%s\n' "$(template_dir)/短视频逐字稿.md" ;;
    longform|xiaohongshu) printf '%s\n' "$(template_dir)/长文.md" ;;
    post) printf '%s\n' "$(template_dir)/短文.md" ;;
    research) printf '%s\n' "$(template_dir)/研究笔记.md" ;;
    *)
      printf 'Unknown type: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

target_path_for_type_title() {
  local type="$1"
  local title
  title="$(safe_title "$2")"

  case "$type" in
    research)
      printf '%s/%s--%s.md\n' "$(route_dir "$type")" "$(dot_date)" "$title"
      ;;
    *)
      printf '%s/%s--%s.md\n' "$(route_dir "$type")" "$(dot_date)" "$title"
      ;;
  esac
}

render_template() {
  local template="$1"
  local output="$2"
  local title="${3:-}"
  local date_text="${4:-$(human_date)}"
  local type="${5:-}"
  local status="${6:-待发布}"

  cp "$template" "$output"
  TITLE="$title" DATE="$date_text" TYPE="$type" STATUS="$status" perl -0pi -e '
    s/\{\{TITLE\}\}/$ENV{TITLE}/g;
    s/\{\{DATE\}\}/$ENV{DATE}/g;
    s/\{\{TYPE\}\}/$ENV{TYPE}/g;
    s/\{\{STATUS\}\}/$ENV{STATUS}/g;
  ' "$output"
}

