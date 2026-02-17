param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("manual", "generated")]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [string]$Title,

  [Parameter(Mandatory = $true)]
  [string]$Details
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DateUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss 'UTC'")

switch ($Source) {
  "manual" {
    $Target = Join-Path $RepoDir "learning\manual\entries.md"
  }
  "generated" {
    $Target = Join-Path $RepoDir "learning\generated\entries.md"
  }
}

New-Item -ItemType Directory -Force (Split-Path -Parent $Target) | Out-Null
if (!(Test-Path $Target)) {
  New-Item -ItemType File -Path $Target | Out-Null
}

$Entry = @"
- [$DateUtc] $Title
  - source: $Source
  - details: $Details
"@

Add-Content -Path $Target -Value $Entry
Write-Host "Added $Source learning entry to $Target"
