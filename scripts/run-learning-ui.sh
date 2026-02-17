#!/usr/bin/env bash
set -euo pipefail

port="${1:-8765}"
repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$repoDir/scripts/learningUiServer.py" --repo-dir "$repoDir" --port "$port"
