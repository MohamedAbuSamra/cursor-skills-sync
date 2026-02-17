# One-command setup: sync this repo's skills into Cursor/Codex and optionally install hooks.
$ErrorActionPreference = "Stop"
$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoDir

Write-Host "Setting up cursor-skills-sync..."
.\sync.ps1 to-local
Write-Host ""
Write-Host "To install git hooks (optional), run in Git Bash: ./scripts/installHooks.sh"
Write-Host ""
Write-Host "Done. Restart Cursor so it picks up the skills."
Write-Host "Optional: run .\scripts\run-learning-ui.ps1 -Port 8765 and open http://127.0.0.1:8765 for the learning dashboard."
