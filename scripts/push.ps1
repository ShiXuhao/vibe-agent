param(
  [Parameter(Position = 0)]
  [string]$Message = "chore: update",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if (Test-Path ".git/index.lock") {
  Remove-Item -Force ".git/index.lock"
}

git rm -r --cached --ignore-unmatch ".trae" "trae" | Out-Null
git rm -r --cached --ignore-unmatch "src/vibe_agent.egg-info" | Out-Null

git add -A

$status = git status --porcelain
if (-not $status) {
  Write-Output "Nothing to commit."
  exit 0
}

git commit -m $Message

if ($Force) {
  git push --force-with-lease origin main
} else {
  git push origin main
}
