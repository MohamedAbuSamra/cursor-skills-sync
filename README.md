# cursor-skills-sync

Sync your Cursor/Codex skills across machines with GitHub.

## Quick setup (one command)

**macOS / Linux**

```bash
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync
chmod +x ./setup.sh
./setup.sh
```

Then **restart Cursor**. Skills from this repo are now active.

**Windows (PowerShell)**

```powershell
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync
.\setup.ps1
```

Then **restart Cursor**.

---

## What this repo contains

- `cursor/skills/` -> custom Cursor skills
- `cursor/skills-cursor/` -> Cursor helper skills
- `codex/skills/` -> Codex skills
- `learning/manual/` -> manually captured learnings
- `learning/generated/` -> AI-generated learnings

## Important difference: learning vs skills

- `learning/*` is a draft log (notes and experiments). It does not directly change assistant behavior.
- `skills/*` is active guidance (`SKILL.md`) used by the assistant.
- Use this flow: capture idea in `learning/*` -> validate in real work -> promote to `skills/*`.

Quick rule:

- If the idea is new/unproven, store it in `learning/*`.
- If the idea is stable/reusable, convert it into a skill.

## Restore on another machine

Use the **Quick setup** above (`./setup.sh` or `.\setup.ps1`). Or manually: run `./sync.sh to-local` (or `.\sync.ps1 to-local`) from this repo, then restart Cursor.

## Update this repo after local changes

Run these from this repo folder:

```bash
./sync.sh to-repo

git add .
git commit -m "chore: sync local skills"
git push
```

For Windows:

```powershell
.\sync.ps1 to-repo
git add .
git commit -m "chore: sync local skills"
git push
```

## Git hooks and CI guard

Install local hooks once per machine:

```bash
chmod +x ./scripts/installHooks.sh
./scripts/installHooks.sh
```

What you get:

- `pre-commit`: runs `scripts/validateSkills.sh`
- `post-commit`: reminds you to push after `SKILL.md` changes
- GitHub Action (`skills-guard`): validates skills on push/PR

## Learning review + promotion commands

Text UI (dashboard):

```bash
./scripts/learning-dashboard.sh 10
```

Local web UI:

```bash
./scripts/run-learning-ui.sh 8765
```

Then open `http://127.0.0.1:8765`.

Review a learning:

```bash
./scripts/review-learning.sh generated <fingerprint> approved "validated in 3 tasks"
```

Promote approved learning into a real skill:

```bash
./scripts/promote-learning.sh generated <fingerprint> my-skill-slug "Short skill description" skills
```

PowerShell equivalents:

```powershell
.\scripts\learning-dashboard.ps1 -Limit 10
.\scripts\run-learning-ui.ps1 -Port 8765
.\scripts\review-learning.ps1 -Source generated -Fingerprint <fingerprint> -Status approved -Reason "validated in 3 tasks"
.\scripts\promote-learning.ps1 -Source generated -Fingerprint <fingerprint> -Slug my-skill-slug -Description "Short skill description" -Target skills
```

## Learning flow (manual vs generated)

Track daily improvements without mixing the source:

### macOS / Linux

```bash
chmod +x ./record-learning.sh
./record-learning.sh manual "title" "details from your own decision"
./record-learning.sh generated "title" "details from AI suggestion"
```

### Windows (PowerShell)

```powershell
.\record-learning.ps1 manual "title" "details from your own decision"
.\record-learning.ps1 generated "title" "details from AI suggestion"
```

See `LEARNING-FLOW.md` for the full daily/weekly process.

Built-in behavior:

- no duplicate entries (same source+title+details)
- every new entry starts as `status: pending`
- reminder when pending entries reach threshold (default: 5, configurable with `learningReviewThrasholder`)

## Promote a learning into a skill

1. Pick a validated entry from `learning/manual/entries.md` or `learning/generated/entries.md`.
2. Create/update a folder under `cursor/skills/` or `cursor/skills-cursor/`.
3. Add or update `SKILL.md` with clear instructions and examples.
4. Commit and push.
