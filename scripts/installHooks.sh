#!/usr/bin/env bash
set -euo pipefail

repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hooksSrc="$repoDir/.githooks"
hooksDest="$repoDir/.git/hooks"

mkdir -p "$hooksDest"

cp "$hooksSrc/pre-commit" "$hooksDest/pre-commit"
cp "$hooksSrc/post-commit" "$hooksDest/post-commit"

chmod +x "$hooksDest/pre-commit" "$hooksDest/post-commit"
chmod +x \
  "$repoDir/scripts/validateSkills.sh" \
  "$repoDir/scripts/review-learning.sh" \
  "$repoDir/scripts/promote-learning.sh" \
  "$repoDir/scripts/learning-dashboard.sh"

echo "Installed hooks into $hooksDest"
echo "Active hooks: pre-commit, post-commit"
