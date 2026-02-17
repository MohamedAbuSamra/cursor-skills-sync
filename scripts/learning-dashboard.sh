#!/usr/bin/env bash
set -euo pipefail

limit="${1:-10}"
repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$repoDir/scripts/learningManager.py" \
  --repo-dir "$repoDir" \
  dashboard \
  --limit "$limit"
