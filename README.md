# cursor-skills-sync

Sync your Cursor/Codex skills across machines with GitHub.

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

### macOS / Linux

```bash
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync
chmod +x ./sync.sh
./sync.sh to-local
```

Then restart Cursor.

### Windows (PowerShell)

```powershell
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync
.\sync.ps1 to-local
```

Then restart Cursor.

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

## Promote a learning into a skill

1. Pick a validated entry from `learning/manual/entries.md` or `learning/generated/entries.md`.
2. Create/update a folder under `cursor/skills/` or `cursor/skills-cursor/`.
3. Add or update `SKILL.md` with clear instructions and examples.
4. Commit and push.

