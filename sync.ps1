param(
  [ValidateSet("to-local", "to-repo")]
  [string]$Mode = "to-local"
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$SharedSkillsRepo = Join-Path $RepoDir "skills"
$CursorSkillsCursorRepo = Join-Path $RepoDir "cursor\skills-cursor"
$CodexSkillsRepo = Join-Path $RepoDir "codex\skills"
$ClaudeSkillsRepo = Join-Path $RepoDir "claude\skills"
$ClaudeClaudeMdRepo = Join-Path $RepoDir "claude\CLAUDE.md"

$SharedSkillsLocal = Join-Path $HOME ".cursor\skills"
$CursorSkillsCursorLocal = Join-Path $HOME ".cursor\skills-cursor"
$CodexSkillsLocal = Join-Path $HOME ".codex\skills"
$ClaudeSkillsLocal = Join-Path $HOME ".claude\skills"
$ClaudeClaudeMdLocal = Join-Path $HOME ".claude\CLAUDE.md"

function Ensure-Dir([string]$Path) {
  New-Item -ItemType Directory -Force $Path | Out-Null
}

function Sync-Dir([string]$Source, [string]$Destination) {
  Ensure-Dir $Source
  Ensure-Dir $Destination

  # Robocopy mirrors content and handles deletes (/MIR).
  robocopy $Source $Destination /MIR /NFL /NDL /NJH /NJS /NC /NS | Out-Null
  if ($LASTEXITCODE -gt 7) {
    throw "robocopy failed with exit code $LASTEXITCODE while syncing '$Source' -> '$Destination'."
  }
}

function Generate-ClaudeMd([string]$Dest) {
  Ensure-Dir (Split-Path $Dest)
  $parts = [System.Collections.Generic.List[string]]::new()
  $parts.Add((Get-Content -Raw -LiteralPath $ClaudeClaudeMdRepo))
  $parts.Add("`n---`n`n<!-- AUTO-GENERATED from ~/ai-agent-skills-sync/skills/ and claude/skills/ — edit skill files there, not here -->`n")
  $parts.Add("`n# Shared Skills`n")
  Get-ChildItem -Path (Join-Path $RepoDir "skills") -Filter "SKILL.md" -Recurse | Sort-Object FullName | ForEach-Object {
    $parts.Add("`n---`n`n")
    $parts.Add((Get-Content -Raw -LiteralPath $_.FullName))
  }
  $parts.Add("`n---`n`n# Claude Code Skills`n")
  Get-ChildItem -Path (Join-Path $RepoDir "claude\skills") -Filter "SKILL.md" -Recurse | Sort-Object FullName | ForEach-Object {
    $parts.Add("`n---`n`n")
    $parts.Add((Get-Content -Raw -LiteralPath $_.FullName))
  }
  [System.IO.File]::WriteAllText($Dest, ($parts -join ""), [System.Text.Encoding]::UTF8)
}

switch ($Mode) {
  "to-local" {
    Sync-Dir $SharedSkillsRepo $SharedSkillsLocal
    Sync-Dir $CursorSkillsCursorRepo $CursorSkillsCursorLocal
    Sync-Dir $CodexSkillsRepo $CodexSkillsLocal
    Sync-Dir $ClaudeSkillsRepo $ClaudeSkillsLocal
    Generate-ClaudeMd $ClaudeClaudeMdLocal
    Write-Host "Synced repo -> local skill directories."
  }
  "to-repo" {
    Sync-Dir $SharedSkillsLocal $SharedSkillsRepo
    Sync-Dir $CursorSkillsCursorLocal $CursorSkillsCursorRepo
    Sync-Dir $CodexSkillsLocal $CodexSkillsRepo
    Sync-Dir $ClaudeSkillsLocal $ClaudeSkillsRepo
    Write-Host "Synced local -> repo directories."
  }
}
