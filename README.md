# cursor-skills-sync

Sync your Cursor/Codex skills across machines with GitHub.

## What this repo contains

- `cursor/skills/` -> custom Cursor skills
- `cursor/skills-cursor/` -> Cursor helper skills
- `codex/skills/` -> Codex skills

## Restore on another machine

### macOS / Linux

```bash
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync

mkdir -p ~/.cursor/skills ~/.cursor/skills-cursor ~/.codex/skills
rsync -a cursor/skills/ ~/.cursor/skills/
rsync -a cursor/skills-cursor/ ~/.cursor/skills-cursor/
rsync -a codex/skills/ ~/.codex/skills/
```

Then restart Cursor.

### Windows (PowerShell)

```powershell
git clone https://github.com/MohamedAbuSamra/cursor-skills-sync.git
cd cursor-skills-sync

New-Item -ItemType Directory -Force "$HOME\.cursor\skills" | Out-Null
New-Item -ItemType Directory -Force "$HOME\.cursor\skills-cursor" | Out-Null
New-Item -ItemType Directory -Force "$HOME\.codex\skills" | Out-Null

Copy-Item -Path ".\cursor\skills\*" -Destination "$HOME\.cursor\skills" -Recurse -Force
Copy-Item -Path ".\cursor\skills-cursor\*" -Destination "$HOME\.cursor\skills-cursor" -Recurse -Force
Copy-Item -Path ".\codex\skills\*" -Destination "$HOME\.codex\skills" -Recurse -Force
```

Then restart Cursor.

## Update this repo after local changes

Run these from this repo folder:

```bash
rsync -a ~/.cursor/skills/ cursor/skills/
rsync -a ~/.cursor/skills-cursor/ cursor/skills-cursor/
rsync -a ~/.codex/skills/ codex/skills/

git add .
git commit -m "chore: sync local skills"
git push
```

