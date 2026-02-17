param(
  [int]$Limit = 10
)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

python3 "$RepoDir/scripts/learningManager.py" `
  --repo-dir "$RepoDir" `
  dashboard `
  --limit "$Limit"
