#!/usr/bin/env bash
set -euo pipefail

repoDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running skill validation..."

repoDir="$repoDir" python3 - <<'PY'
from pathlib import Path
import os
import re
import sys

repo_dir = Path(os.environ.get("repoDir", ".")).resolve()
skill_roots = [
    repo_dir / "cursor" / "skills",
    repo_dir / "cursor" / "skills-cursor",
    repo_dir / "codex" / "skills",
]

skill_files = []
for root in skill_roots:
    if root.exists():
        skill_files.extend(sorted(root.rglob("SKILL.md")))

has_failure = False

for file_path in skill_files:
    text = file_path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    rel = file_path.relative_to(repo_dir)

    if not lines or lines[0].strip() != "---":
        print(f"ERROR: {rel} missing frontmatter start '---'")
        has_failure = True
        continue

    end_idx = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        print(f"ERROR: {rel} missing frontmatter end '---'")
        has_failure = True
        continue

    frontmatter = "\n".join(lines[1:end_idx])
    if not re.search(r"^name:\s*.+$", frontmatter, flags=re.MULTILINE):
        print(f"ERROR: {rel} missing 'name:' in frontmatter")
        has_failure = True
    if not re.search(r"^description:\s*.+$", frontmatter, flags=re.MULTILINE):
        print(f"ERROR: {rel} missing 'description:' in frontmatter")
        has_failure = True

for path in repo_dir.rglob("*"):
    if not path.is_file():
        continue
    rel = path.relative_to(repo_dir)
    if rel.as_posix() == "scripts/validateSkills.sh":
        continue
    # Skip binary-ish images.
    if path.suffix.lower() in {".png", ".jpg", ".jpeg", ".gif", ".webp"}:
        continue
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        continue
    if "LEARNING_REVIEW_THRESHOLD" in content:
        print(
            f"ERROR: {rel} contains deprecated key 'LEARNING_REVIEW_THRESHOLD'. "
            "Use 'learningReviewThrasholder'."
        )
        has_failure = True

if has_failure:
    print("Skill validation failed.")
    sys.exit(1)

print("Skill validation passed.")
PY
