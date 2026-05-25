#!/usr/bin/env bash
# Verify setup: skills synced, hooks present.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAIL=0

check() {
  if eval "$1"; then
    echo "  OK $2"
  else
    echo "  FAIL $2"
    FAIL=1
  fi
}

echo "Verifying ai-agent-skills-sync setup..."
check "test -d \"$REPO_DIR/skills\" && test \"\$(ls -A \"$REPO_DIR/skills\" 2>/dev/null)\"" "skills exists and has content"
check "test -d \"$HOME/.cursor/skills\" && test \"\$(ls -A \"$HOME/.cursor/skills\" 2>/dev/null)\"" "~/.cursor/skills exists and has content"
check "test -d \"$HOME/.codex/skills\" && test \"\$(ls -A \"$HOME/.codex/skills\" 2>/dev/null)\"" "~/.codex/skills exists and has content"
check "test -f \"$HOME/.claude/CLAUDE.md\"" "~/.claude/CLAUDE.md installed"
check "test -f \"$REPO_DIR/.git/hooks/pre-commit\"" "pre-commit hook installed"
check "test -f \"$REPO_DIR/.git/hooks/post-commit\"" "post-commit hook installed"
SKILL_COUNT=$(find "$HOME/.cursor/skills" -name "SKILL.md" 2>/dev/null | wc -l)
CODEX_SKILL_COUNT=$(find "$HOME/.codex/skills" -name "SKILL.md" 2>/dev/null | wc -l)
check "test \"$SKILL_COUNT\" -gt 0" "at least one SKILL.md in ~/.cursor/skills (found $SKILL_COUNT)"
check "test \"$CODEX_SKILL_COUNT\" -gt 0" "at least one SKILL.md in ~/.codex/skills (found $CODEX_SKILL_COUNT)"

if [ $FAIL -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed. Run ./setup.sh and restart Cursor, Codex, and Claude Code."
  exit 1
fi
