param(
  [int]$Port = 8765
)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

python3 "$RepoDir/scripts/learningUiServer.py" --repo-dir "$RepoDir" --port $Port
