#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-to-local}"

CURSOR_SKILLS_SRC="$REPO_DIR/cursor/skills/"
CURSOR_SKILLS_CURSOR_SRC="$REPO_DIR/cursor/skills-cursor/"
CODEX_SKILLS_SRC="$REPO_DIR/codex/skills/"

CURSOR_SKILLS_DEST="$HOME/.cursor/skills/"
CURSOR_SKILLS_CURSOR_DEST="$HOME/.cursor/skills-cursor/"
CODEX_SKILLS_DEST="$HOME/.codex/skills/"

ensure_repo_structure() {
  mkdir -p "$REPO_DIR/cursor/skills" "$REPO_DIR/cursor/skills-cursor" "$REPO_DIR/codex/skills"
}

ensure_local_structure() {
  mkdir -p "$HOME/.cursor/skills" "$HOME/.cursor/skills-cursor" "$HOME/.codex/skills"
}

case "$MODE" in
  to-local)
    ensure_local_structure
    rsync -a --delete "$CURSOR_SKILLS_SRC" "$CURSOR_SKILLS_DEST"
    rsync -a --delete "$CURSOR_SKILLS_CURSOR_SRC" "$CURSOR_SKILLS_CURSOR_DEST"
    rsync -a --delete "$CODEX_SKILLS_SRC" "$CODEX_SKILLS_DEST"
    echo "Synced repo -> local skill directories."
    ;;
  to-repo)
    ensure_repo_structure
    rsync -a --delete "$CURSOR_SKILLS_DEST" "$CURSOR_SKILLS_SRC"
    rsync -a --delete "$CURSOR_SKILLS_CURSOR_DEST" "$CURSOR_SKILLS_CURSOR_SRC"
    rsync -a --delete "$CODEX_SKILLS_DEST" "$CODEX_SKILLS_SRC"
    echo "Synced local -> repo directories."
    ;;
  *)
    echo "Usage: $0 [to-local|to-repo]" >&2
    exit 1
    ;;
esac
