#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: $0 /absolute/path/to/target-repo" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

cp "$REPO_DIR/templates/copilot-instructions-template.md" "$TARGET_DIR/copilot-instructions.md"
cp "$REPO_DIR/templates/AGENTS-template.md" "$TARGET_DIR/AGENTS.md"
cp "$REPO_DIR/templates/CLAUDE-template.md" "$TARGET_DIR/CLAUDE.md"

echo "Installed repo bootstrap into: $TARGET_DIR"
echo "Created: $TARGET_DIR/copilot-instructions.md"
echo "Created: $TARGET_DIR/AGENTS.md"
echo "Created: $TARGET_DIR/CLAUDE.md"