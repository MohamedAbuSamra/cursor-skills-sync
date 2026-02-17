#!/usr/bin/env bash
# One-command setup: sync this repo's skills into Cursor/Codex and optionally install hooks.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo "Setting up cursor-skills-sync..."
chmod +x ./sync.sh
chmod +x ./record-learning.sh
chmod +x ./scripts/installHooks.sh
chmod +x ./scripts/validateSkills.sh
chmod +x ./scripts/run-learning-ui.sh
chmod +x ./scripts/learning-dashboard.sh
chmod +x ./scripts/review-learning.sh
chmod +x ./scripts/promote-learning.sh

./sync.sh to-local
echo ""
echo "Installing git hooks..."
./scripts/installHooks.sh
echo ""
echo "Verifying..."
chmod +x ./verify.sh
./verify.sh
echo ""
echo "Done. Restart Cursor so it picks up the skills."
echo "Optional: run ./scripts/run-learning-ui.sh 8765 and open http://127.0.0.1:8765 for the learning dashboard."
