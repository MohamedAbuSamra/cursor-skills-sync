$ErrorActionPreference = "Stop"

param(
  [Parameter(Mandatory = $true)]
  [string]$TargetDir
)

$repoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) {
  throw "Target directory does not exist: $TargetDir"
}

Copy-Item -LiteralPath (Join-Path $repoDir "templates/copilot-instructions-template.md") -Destination (Join-Path $TargetDir "copilot-instructions.md") -Force
Copy-Item -LiteralPath (Join-Path $repoDir "templates/AGENTS-template.md") -Destination (Join-Path $TargetDir "AGENTS.md") -Force
Copy-Item -LiteralPath (Join-Path $repoDir "templates/CLAUDE-template.md") -Destination (Join-Path $TargetDir "CLAUDE.md") -Force

Write-Host "Installed repo bootstrap into: $TargetDir"
Write-Host "Created: $(Join-Path $TargetDir 'copilot-instructions.md')"
Write-Host "Created: $(Join-Path $TargetDir 'AGENTS.md')"
Write-Host "Created: $(Join-Path $TargetDir 'CLAUDE.md')"