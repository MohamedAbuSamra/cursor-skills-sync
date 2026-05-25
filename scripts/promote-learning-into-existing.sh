#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <manual|generated> <fingerprint> <skill-slug> [skills|skills-cursor]" >&2
  exit 1
fi

sourceType="$1"
fingerprint="$2"
skillSlug="$3"
target="${4:-skills}"
repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$repoDir/scripts/learningManager.py" \
  --repo-dir "$repoDir" \
  promote-into-existing \
  --source "$sourceType" \
  --fingerprint "$fingerprint" \
  --skill-slug "$skillSlug" \
  --target "$target"