$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$existing = & git -C $repoRoot config --get core.hooksPath
if ($LASTEXITCODE -notin @(0, 1)) {
    throw 'Unable to read Git hook configuration.'
}
if ($existing -and $existing -ne '.githooks') {
    throw "Existing core.hooksPath is '$existing'. Integrate .githooks/pre-commit with those hooks before replacing the setting."
}
& git -C $repoRoot config --local core.hooksPath .githooks
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to configure repository hooks.'
}
Write-Output 'Enabled .githooks/pre-commit for this checkout.'
