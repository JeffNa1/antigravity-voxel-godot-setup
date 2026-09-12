<#
.SYNOPSIS
    One-Line Quick Bootstrap for Antigravity Voxel & Godot Environment
.EXAMPLE
    irm https://raw.githubusercontent.com/JeffNa1/antigravity-voxel-godot-setup/main/bootstrap.ps1 | iex
#>

$RepoUrl = "https://github.com/JeffNa1/antigravity-voxel-godot-setup.git"
$CloneDir = Join-Path $env:TEMP "antigravity-voxel-godot-setup"

Write-Host ">>> Fetching Antigravity Environment Kit from $RepoUrl..." -ForegroundColor Cyan

if (Test-Path $CloneDir) {
    Remove-Item -Path $CloneDir -Recurse -Force -ErrorAction SilentlyContinue
}

git clone --depth 1 $RepoUrl $CloneDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to clone repository from $RepoUrl"
    exit 1
}

$InstallerPath = Join-Path $CloneDir "install.ps1"
if (Test-Path $InstallerPath) {
    & $InstallerPath
} else {
    Write-Error "install.ps1 not found in cloned repository."
}
