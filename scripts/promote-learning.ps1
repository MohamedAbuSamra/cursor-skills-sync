param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("manual", "generated")]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [string]$Fingerprint,

  [Parameter(Mandatory = $true)]
  [string]$Slug,

  [Parameter(Mandatory = $true)]
  [string]$Description,

  [ValidateSet("skills", "skills-cursor")]
  [string]$Target = "skills"
)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

python3 "$RepoDir/scripts/learningManager.py" `
  --repo-dir "$RepoDir" `
  promote `
  --source "$Source" `
  --fingerprint "$Fingerprint" `
  --slug "$Slug" `
  --description "$Description" `
  --target "$Target"
