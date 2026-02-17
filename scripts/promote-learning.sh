#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <manual|generated> <fingerprint> <slug> <description> [skills|skills-cursor]" >&2
  exit 1
fi

sourceType="$1"
fingerprint="$2"
slug="$3"
description="$4"
target="${5:-skills}"
repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$repoDir/scripts/learningManager.py" \
  --repo-dir "$repoDir" \
  promote \
  --source "$sourceType" \
  --fingerprint "$fingerprint" \
  --slug "$slug" \
  --description "$description" \
  --target "$target"
