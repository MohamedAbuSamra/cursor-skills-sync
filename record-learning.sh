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
REVIEW_THRESHOLD="${LEARNING_REVIEW_THRESHOLD:-5}"

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

FINGERPRINT="$(
  printf "%s" "$SOURCE|$TITLE|$DETAILS" \
    | shasum -a 256 \
    | awk '{print $1}'
)"

if awk -v fp="$FINGERPRINT" 'index($0, "  - fingerprint: " fp) > 0 { found=1 } END { exit(found ? 0 : 1) }' "$TARGET"; then
  echo "Duplicate learning skipped (fingerprint already exists)."
else
{
  echo "- [$DATE_UTC] $TITLE"
  echo "  - fingerprint: $FINGERPRINT"
  echo "  - source: $SOURCE"
  echo "  - status: pending"
  echo "  - details: $DETAILS"
} >> "$TARGET"

  echo "Added $SOURCE learning entry to $TARGET"
fi

PENDING_COUNT="$(
  awk '
    /- status: pending/ {count++}
    END {print count+0}
  ' "$REPO_DIR/learning/manual/entries.md" "$REPO_DIR/learning/generated/entries.md" 2>/dev/null || echo 0
)"

if [[ "$PENDING_COUNT" -ge "$REVIEW_THRESHOLD" ]]; then
  echo
  echo "Reminder: you have $PENDING_COUNT pending learnings to review."
  echo "Review target reached (threshold: $REVIEW_THRESHOLD)."
  echo "Next step: approve/reject/promote pending entries."
fi
