# Conceptual OpenTofu / provider schema check for pathlyhq/pathly examples.
# Does not call the Pathly API. Skips tofu fmt/validate when tofu is missing.
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Example = Join-Path $Root "examples\complete"
$Main = Join-Path $Example "main.tf"

function Fail([string]$Message) {
  Write-Error "FAIL: $Message"
  exit 1
}
function Ok([string]$Message) { Write-Host "OK: $Message" }

if (-not (Test-Path $Main)) { Fail "missing $Main" }

$mainText = Get-Content -Raw $Main

if ($mainText -notmatch 'source\s*=\s*"pathlyhq/pathly"') {
  Fail 'expected required_providers source = "pathlyhq/pathly"'
}
Ok "provider source pathlyhq/pathly"

foreach ($type in @(
  "pathly_scenario",
  "pathly_webhook",
  "pathly_maintenance_window",
  "pathly_sla_target"
)) {
  if ($mainText -notmatch [regex]::Escape("resource `"$type`"")) {
    Fail "example must declare resource `"$type`""
  }
  Ok "resource $type present"
}

$readme = Get-Content -Raw (Join-Path $Root "README.md")
if ($readme -notmatch "PATHLY_API_TOKEN") {
  Fail "README.md must document PATHLY_API_TOKEN"
}
Ok "PATHLY_API_TOKEN documented"

if ($mainText -notmatch 'provider\s+"pathly"\s+\{\s*\}') {
  Fail 'expected provider "pathly" {} (token from PATHLY_API_TOKEN)'
}
Ok "provider block uses env auth"

$tofu = Get-Command tofu -ErrorAction SilentlyContinue
if ($null -ne $tofu) {
  Ok "tofu available: $((& tofu version) | Select-Object -First 1)"
  Push-Location $Example
  try {
    & tofu fmt -check -recursive
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    & tofu init -backend=false -input=false
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    & tofu validate
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  } finally {
    Pop-Location
  }
  Ok "tofu fmt + validate passed"
} else {
  Write-Host "SKIP: tofu not installed — conceptual checks only (install OpenTofu to run fmt/validate)."
}

Write-Host ""
Write-Host "All conceptual compatibility checks passed."
