#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-to-local}"

SHARED_SKILLS_SRC="$REPO_DIR/skills/"
CURSOR_SKILLS_CURSOR_SRC="$REPO_DIR/cursor/skills-cursor/"
CODEX_SKILLS_SRC="$REPO_DIR/codex/skills/"
CLAUDE_SKILLS_SRC="$REPO_DIR/claude/skills/"
CLAUDE_CLAUDE_MD_SRC="$REPO_DIR/claude/CLAUDE.md"

SHARED_SKILLS_DEST="$HOME/.cursor/skills/"
CURSOR_SKILLS_CURSOR_DEST="$HOME/.cursor/skills-cursor/"
CODEX_SKILLS_DEST="$HOME/.codex/skills/"
CLAUDE_SKILLS_DEST="$HOME/.claude/skills/"
CLAUDE_CLAUDE_MD_DEST="$HOME/.claude/CLAUDE.md"

ensure_repo_structure() {
  mkdir -p "$REPO_DIR/skills" "$REPO_DIR/cursor/skills-cursor" "$REPO_DIR/codex/skills" "$REPO_DIR/claude/skills"
}

ensure_local_structure() {
  mkdir -p "$HOME/.cursor/skills" "$HOME/.cursor/skills-cursor" "$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.claude"
}

generate_claude_md() {
  local dest="$1"
  {
    cat "$CLAUDE_CLAUDE_MD_SRC"
    printf '\n---\n\n<!-- AUTO-GENERATED from ~/ai-agent-skills-sync/skills/ and claude/skills/ — edit skill files there, not here -->\n'
    printf '\n# Shared Skills\n'
    while IFS= read -r skill_file; do
      printf '\n---\n\n'
      cat "$skill_file"
    done < <(find "$REPO_DIR/skills" -name "SKILL.md" | sort)
    printf '\n---\n\n# Claude Code Skills\n'
    while IFS= read -r skill_file; do
      printf '\n---\n\n'
      cat "$skill_file"
    done < <(find "$REPO_DIR/claude/skills" -name "SKILL.md" | sort)
  } > "$dest"
}

case "$MODE" in
  to-local)
    ensure_local_structure
    rsync -a --delete "$SHARED_SKILLS_SRC" "$SHARED_SKILLS_DEST"
    rsync -a --delete "$CURSOR_SKILLS_CURSOR_SRC" "$CURSOR_SKILLS_CURSOR_DEST"
    # Codex gets shared skills + any codex-specific skills
    rsync -a "$SHARED_SKILLS_SRC" "$CODEX_SKILLS_DEST"
    rsync -a "$CODEX_SKILLS_SRC" "$CODEX_SKILLS_DEST"
    rsync -a --delete "$CLAUDE_SKILLS_SRC" "$CLAUDE_SKILLS_DEST"
    generate_claude_md "$CLAUDE_CLAUDE_MD_DEST"
    echo "Synced repo -> local skill directories."
    ;;
  to-repo)
    ensure_repo_structure
    rsync -a --delete "$SHARED_SKILLS_DEST" "$SHARED_SKILLS_SRC"
    rsync -a --delete "$CURSOR_SKILLS_CURSOR_DEST" "$CURSOR_SKILLS_CURSOR_SRC"
    rsync -a --delete "$CODEX_SKILLS_DEST" "$CODEX_SKILLS_SRC"
    rsync -a --delete "$CLAUDE_SKILLS_DEST" "$CLAUDE_SKILLS_SRC"
    echo "Synced local -> repo directories."
    ;;
  *)
    echo "Usage: $0 [to-local|to-repo]" >&2
    exit 1
    ;;
esac
