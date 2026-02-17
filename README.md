# cursor-skills-sync

Sync your Cursor/Codex skills across machines with GitHub.

## What this repo contains

- `cursor/skills/` -> custom Cursor skills
- `cursor/skills-cursor/` -> Cursor helper skills
- `codex/skills/` -> Codex skills
- `learning/manual/` -> manually captured learnings
- `learning/generated/` -> AI-generated learnings

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

