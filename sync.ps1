param(
  [ValidateSet("to-local", "to-repo")]
  [string]$Mode = "to-local"
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$CursorSkillsRepo = Join-Path $RepoDir "cursor\skills"
$CursorSkillsCursorRepo = Join-Path $RepoDir "cursor\skills-cursor"
$CodexSkillsRepo = Join-Path $RepoDir "codex\skills"

$CursorSkillsLocal = Join-Path $HOME ".cursor\skills"
$CursorSkillsCursorLocal = Join-Path $HOME ".cursor\skills-cursor"
$CodexSkillsLocal = Join-Path $HOME ".codex\skills"

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

switch ($Mode) {
  "to-local" {
    Sync-Dir $CursorSkillsRepo $CursorSkillsLocal
    Sync-Dir $CursorSkillsCursorRepo $CursorSkillsCursorLocal
    Sync-Dir $CodexSkillsRepo $CodexSkillsLocal
    Write-Host "Synced repo -> local skill directories."
  }
  "to-repo" {
    Sync-Dir $CursorSkillsLocal $CursorSkillsRepo
    Sync-Dir $CursorSkillsCursorLocal $CursorSkillsCursorRepo
    Sync-Dir $CodexSkillsLocal $CodexSkillsRepo
    Write-Host "Synced local -> repo directories."
  }
}
