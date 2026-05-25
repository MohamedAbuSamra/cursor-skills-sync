param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("manual", "generated")]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [string]$Fingerprint,

  [Parameter(Mandatory = $true)]
  [string]$SkillSlug,

  [ValidateSet("skills", "skills-cursor")]
  [string]$Target = "skills"
)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

python3 "$RepoDir/scripts/learningManager.py" `
  --repo-dir "$RepoDir" `
  promote-into-existing `
  --source "$Source" `
  --fingerprint "$Fingerprint" `
  --skill-slug "$SkillSlug" `
  --target "$Target"