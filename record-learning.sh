#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <manual|generated> <title> <details>" >&2
  exit 1
fi

SOURCE="$1"
TITLE="$2"
DETAILS="$3"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATE_UTC="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

case "$SOURCE" in
  manual)
    TARGET="$REPO_DIR/learning/manual/entries.md"
    ;;
  generated)
    TARGET="$REPO_DIR/learning/generated/entries.md"
    ;;
  *)
    echo "First argument must be 'manual' or 'generated'." >&2
    exit 1
    ;;
esac

mkdir -p "$REPO_DIR/learning/manual" "$REPO_DIR/learning/generated"
touch "$TARGET"

{
  echo "- [$DATE_UTC] $TITLE"
  echo "  - source: $SOURCE"
  echo "  - details: $DETAILS"
} >> "$TARGET"

echo "Added $SOURCE learning entry to $TARGET"
