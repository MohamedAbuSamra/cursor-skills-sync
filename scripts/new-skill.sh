#!/usr/bin/env bash
# Scaffold a new skill directly — use when the pattern is already well understood.
# Usage: ./scripts/new-skill.sh <slug> "Short description" ["Source book or reference"]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SLUG="${1:-}"
DESCRIPTION="${2:-}"
SOURCE="${3:-}"

if [[ -z "$SLUG" || -z "$DESCRIPTION" ]]; then
  echo "Usage: $0 <slug> \"Short description\" [\"Source\"]" >&2
  exit 1
fi

SKILL_DIR="$REPO_DIR/skills/$SLUG"

if [[ -d "$SKILL_DIR" ]]; then
  echo "Skill '$SLUG' already exists at $SKILL_DIR" >&2
  exit 1
fi

mkdir -p "$SKILL_DIR"

cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SLUG
description: $DESCRIPTION${SOURCE:+
source: $SOURCE}
---

# $(echo "$SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

## When to apply

<!-- Describe what triggers this skill -->

## Core principles

<!-- Key rules, patterns, examples -->

## Checklist

- [ ] <!-- Add quality checks -->

## Anti-patterns

- <!-- What to avoid -->
EOF

echo "Created: $SKILL_DIR/SKILL.md"
echo ""
echo "Next steps:"
echo "  1. Fill in the skill content"
echo "  2. Run: ./scripts/validateSkills.sh"
echo "  3. Run: ./sync.sh to-local"
echo "  4. Commit and push"
