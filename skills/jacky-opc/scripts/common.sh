#!/usr/bin/env bash

set -euo pipefail

# Public export note:
# The private version used hard-coded local paths. The open-source version keeps
# the same helper functions but reads paths from environment variables.
if [ -z "${OPC_ROOT:-}" ]; then
  printf 'Missing OPC_ROOT. Example:\n' >&2
  printf '  OPC_ROOT="$HOME/Documents/OPC System" %s\n' "$0" >&2
  exit 1
fi

VAULT_ROOT="${VAULT_ROOT:-$(cd "$OPC_ROOT/.." 2>/dev/null && pwd -P)}"

TOPIC_RECORD="$OPC_ROOT/04.选题决策/选题管理/选题研究/00-选题记录.md"
TOPIC_RESEARCH="$OPC_ROOT/04.选题决策/选题管理/选题研究/01-选题研究.md"

PENDING_SHORT_VIDEO_DIR="$OPC_ROOT/04.选题决策/选题管理/待发布的选题/短视频"
PENDING_LONGFORM_DIR="$OPC_ROOT/04.选题决策/选题管理/待发布的选题/公众号+小红书长文"
PENDING_POST_DIR="$OPC_ROOT/04.选题决策/选题管理/待发布的选题/推文库"

PUBLISHED_SHORT_VIDEO_DIR="$OPC_ROOT/07.发布存档/已发布的选题/短视频"
PUBLISHED_LONGFORM_DIR="$OPC_ROOT/07.发布存档/已发布的选题/公众号+小红书长文"

KNOWLEDGE_DIR="${KNOWLEDGE_DIR:-$VAULT_ROOT/0、知识库}"
STYLE_DIR="${STYLE_DIR:-}"
ARCHIVE_DIR="${ARCHIVE_DIR:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$SKILL_DIR/templates"

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

ensure_managed_paths() {
  mkdir -p \
    "$PENDING_SHORT_VIDEO_DIR" \
    "$PENDING_LONGFORM_DIR" \
    "$PENDING_POST_DIR" \
    "$PUBLISHED_SHORT_VIDEO_DIR" \
    "$PUBLISHED_LONGFORM_DIR" \
    "$OPC_ROOT/04.选题决策/100条谜题" \
    "$OPC_ROOT/04.选题决策/100条非共识" \
    "$OPC_ROOT/08.数据反馈/月度数据分析报告"

  if [ ! -f "$TOPIC_RECORD" ]; then
    mkdir -p "$(dirname "$TOPIC_RECORD")"
    cat >"$TOPIC_RECORD" <<'EOF'
# 00-选题记录

这个文件用于承接还没进入正式写作的内容想法、访谈记录、方向判断和 brief。

EOF
  fi
}

route_dir() {
  case "$1" in
    short-video) printf '%s\n' "$PENDING_SHORT_VIDEO_DIR" ;;
    longform) printf '%s\n' "$PENDING_LONGFORM_DIR" ;;
    xiaohongshu) printf '%s\n' "$PENDING_LONGFORM_DIR" ;;
    post) printf '%s\n' "$PENDING_POST_DIR" ;;
    research) printf '%s\n' "$KNOWLEDGE_DIR" ;;
    published-short-video) printf '%s\n' "$PUBLISHED_SHORT_VIDEO_DIR" ;;
    published-longform) printf '%s\n' "$PUBLISHED_LONGFORM_DIR" ;;
    *)
      printf 'Unknown type: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

template_for_type() {
  case "$1" in
    short-video) printf '%s\n' "$TEMPLATE_DIR/短视频逐字稿.md" ;;
    longform) printf '%s\n' "$TEMPLATE_DIR/长文.md" ;;
    xiaohongshu) printf '%s\n' "$TEMPLATE_DIR/长文.md" ;;
    post) printf '%s\n' "$TEMPLATE_DIR/短文.md" ;;
    research) printf '%s\n' "$TEMPLATE_DIR/研究笔记.md" ;;
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
      printf '%s/%s-%s.md\n' "$(route_dir "$type")" "$title" "$(compact_date)"
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
