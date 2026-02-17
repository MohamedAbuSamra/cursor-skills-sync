#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <manual|generated> <fingerprint> <approved|rejected|pending|promoted> [reason]" >&2
  exit 1
fi

sourceType="$1"
fingerprint="$2"
statusValue="$3"
reason="${4:-}"
repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$repoDir/scripts/learningManager.py" \
  --repo-dir "$repoDir" \
  review \
  --source "$sourceType" \
  --fingerprint "$fingerprint" \
  --status "$statusValue" \
  --reason "$reason"
