param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("manual", "generated")]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [string]$Fingerprint,

  [Parameter(Mandatory = $true)]
  [ValidateSet("approved", "rejected", "pending", "promoted")]
  [string]$Status,

  [string]$Reason = ""
)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

python3 "$RepoDir/scripts/learningManager.py" `
  --repo-dir "$RepoDir" `
  review `
  --source "$Source" `
  --fingerprint "$Fingerprint" `
  --status "$Status" `
  --reason "$Reason"
