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
$learningReviewThrasholder = 5
if ($env:learningReviewThrasholder) {
  $learningReviewThrasholder = [int]$env:learningReviewThrasholder
}

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

$FingerprintInput = "$Source|$Title|$Details"
$FingerprintBytes = [System.Text.Encoding]::UTF8.GetBytes($FingerprintInput)
$Hasher = [System.Security.Cryptography.SHA256]::Create()
$Fingerprint = ([System.BitConverter]::ToString($Hasher.ComputeHash($FingerprintBytes))).Replace("-", "").ToLowerInvariant()
$Hasher.Dispose()

$Existing = Select-String -Path $Target -Pattern "  - fingerprint: $Fingerprint" -SimpleMatch -ErrorAction SilentlyContinue
if ($Existing) {
  Write-Host "Duplicate learning skipped (fingerprint already exists)."
} else {
  $Entry = @"
- [$DateUtc] $Title
  - fingerprint: $Fingerprint
  - source: $Source
  - status: pending
  - details: $Details
"@
  Add-Content -Path $Target -Value $Entry
  Write-Host "Added $Source learning entry to $Target"
}

$ManualPath = Join-Path $RepoDir "learning\manual\entries.md"
$GeneratedPath = Join-Path $RepoDir "learning\generated\entries.md"
$PendingCount = 0
foreach ($Path in @($ManualPath, $GeneratedPath)) {
  if (Test-Path $Path) {
    $PendingCount += (Select-String -Path $Path -Pattern "  - status: pending" -SimpleMatch | Measure-Object).Count
  }
}

if ($PendingCount -ge $learningReviewThrasholder) {
  Write-Host ""
  Write-Host "Reminder: you have $PendingCount pending learnings to review."
  Write-Host "Review target reached (threshold: $learningReviewThrasholder)."
  Write-Host "Next step: approve/reject/promote pending entries."
}
