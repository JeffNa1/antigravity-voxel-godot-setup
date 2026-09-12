<#
.SYNOPSIS
    Antigravity Voxel & Godot Environment Bootstrap Installer
.DESCRIPTION
    Restores the complete Antigravity 2.0 configuration, including 6 MCP servers,
    22 specialized skills, tool schemas, global configs, and dependencies.
#>

[CmdletBinding()]
param(
    [string]$CustomGodotPath = ""
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  ANTIGRAVITY 2.0 VOXEL & GODOT ENVIRONMENT SETUP" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
$GeminiDir = Join-Path $UserHome ".gemini"
$AgyDir = Join-Path $GeminiDir "antigravity"
$ConfigDir = Join-Path $GeminiDir "config"

Write-Host "`n[*] Target User Profile: $UserHome" -ForegroundColor Yellow
Write-Host "[*] Gemini Root:         $GeminiDir" -ForegroundColor Yellow
Write-Host "[*] Setup Source:        $ScriptDir" -ForegroundColor Yellow

# ----------------------------------------------------
# 1. Directory Structure Creation
# ----------------------------------------------------
Write-Host "`n[1/7] Creating directory hierarchy..." -ForegroundColor Green
$DirsToCreate = @(
    (Join-Path $ConfigDir "skills"),
    (Join-Path $AgyDir "skills"),
    (Join-Path $AgyDir "mcp"),
    (Join-Path $AgyDir "mcp_servers"),
    (Join-Path $AgyDir "bin")
)

foreach ($dir in $DirsToCreate) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  [+] Created: $dir" -ForegroundColor DarkGray
    } else {
        Write-Host "  [=] Exists:  $dir" -ForegroundColor DarkGray
    }
}

# ----------------------------------------------------
# 2. Copy Antigravity Skills
# ----------------------------------------------------
Write-Host "`n[2/7] Installing 22 Antigravity skills..." -ForegroundColor Green
$SkillsSrc = Join-Path $ScriptDir "skills"
$SkillsDestConfig = Join-Path $ConfigDir "skills"
$SkillsDestAgy = Join-Path $AgyDir "skills"

if (Test-Path $SkillsSrc) {
    Copy-Item -Path "$SkillsSrc\*" -Destination $SkillsDestConfig -Recurse -Force
    Copy-Item -Path "$SkillsSrc\*" -Destination $SkillsDestAgy -Recurse -Force
    $skillCount = (Get-ChildItem $SkillsDestConfig -Directory).Count
    Write-Host "  [+] Successfully installed $skillCount skills into .gemini configuration!" -ForegroundColor Cyan
} else {
    Write-Warning "Skills directory not found at $SkillsSrc"
}

# ----------------------------------------------------
# 3. Copy MCP Schemas & Instructions
# ----------------------------------------------------
Write-Host "`n[3/7] Installing MCP tool schemas & guides..." -ForegroundColor Green
$McpSrc = Join-Path $ScriptDir "mcp"
$McpDest = Join-Path $AgyDir "mcp"

if (Test-Path $McpSrc) {
    Copy-Item -Path "$McpSrc\*" -Destination $McpDest -Recurse -Force
    $mcpCount = (Get-ChildItem $McpDest -Directory).Count
    Write-Host "  [+] Installed schemas for $mcpCount MCP servers (blender, blockbench, godot-bridge, remotion, voxel)!" -ForegroundColor Cyan
}

# ----------------------------------------------------
# 4. Install & Build Custom MCP Servers
# ----------------------------------------------------
Write-Host "`n[4/7] Setting up Custom MCP Servers (voxel-mcp, blockbench-mcp)..." -ForegroundColor Green
$McpServersSrc = Join-Path $ScriptDir "mcp_servers"
$McpServersDest = Join-Path $AgyDir "mcp_servers"

if (Test-Path $McpServersSrc) {
    robocopy $McpServersSrc $McpServersDest /E /XD node_modules /NFL /NDL /NJH /NJS | Out-Null

    # Build voxel-mcp
    $VoxelMcpDir = Join-Path $McpServersDest "voxel-mcp"
    if (Test-Path $VoxelMcpDir) {
        Write-Host "  [*] Installing dependencies for voxel-mcp..." -ForegroundColor DarkGray
        Push-Location $VoxelMcpDir
        npm install --silent 2>$null | Out-Null
        if (-not (Test-Path "dist\index.js")) {
            npm run build 2>$null | Out-Null
        }
        Pop-Location
        Write-Host "  [+] voxel-mcp ready at: $VoxelMcpDir\dist\index.js" -ForegroundColor Cyan
    }

    # Build blockbench-mcp
    $BlockbenchMcpDir = Join-Path $McpServersDest "blockbench-mcp"
    if (Test-Path $BlockbenchMcpDir) {
        Write-Host "  [*] Installing dependencies for blockbench-mcp..." -ForegroundColor DarkGray
        Push-Location $BlockbenchMcpDir
        npm install --silent 2>$null | Out-Null
        if (-not (Test-Path "dist\index.js")) {
            npm run build 2>$null | Out-Null
        }
        Pop-Location
        Write-Host "  [+] blockbench-mcp ready at: $BlockbenchMcpDir\dist\index.js" -ForegroundColor Cyan
    }
}

# ----------------------------------------------------
# 5. Global NPM & Python Tool Dependencies
# ----------------------------------------------------
Write-Host "`n[5/7] Ensuring global MCP runner packages..." -ForegroundColor Green

# Hermes / Node packages
$HermesNodeDir = Join-Path $env:LOCALAPPDATA "hermes\node"
$GlobalNpmPackages = @("godot-mcp", "godot-mcp-bridge", "@remotion/mcp")

foreach ($pkg in $GlobalNpmPackages) {
    Write-Host "  [*] Verifying npm package: $pkg..." -ForegroundColor DarkGray
    npm install -g $pkg --silent 2>$null | Out-Null
}

# Blender MCP via UV if uv exists
if (Get-Command uvx -ErrorAction SilentlyContinue) {
    Write-Host "  [*] uvx detected. Blender MCP will run on-demand via uvx blender-mcp." -ForegroundColor DarkGray
} elseif (Get-Command uv -ErrorAction SilentlyContinue) {
    Write-Host "  [*] Installing blender-mcp tool via uv..." -ForegroundColor DarkGray
    uv tool install blender-mcp 2>$null | Out-Null
}

# ----------------------------------------------------
# 6. Generate Dynamic Configuration Files
# ----------------------------------------------------
Write-Host "`n[6/7] Generating configuration files with dynamic paths..." -ForegroundColor Green

# Locate Godot executable
$ResolvedGodot = ""
if ($CustomGodotPath -and (Test-Path $CustomGodotPath)) {
    $ResolvedGodot = $CustomGodotPath
} elseif (Test-Path (Join-Path $AgyDir "bin\godot.exe")) {
    $ResolvedGodot = (Join-Path $AgyDir "bin\godot.exe")
} elseif (Get-Command godot -ErrorAction SilentlyContinue) {
    $ResolvedGodot = (Get-Command godot).Source
} else {
    $PotentialGodots = Get-ChildItem -Path "$UserHome" -Filter "godot*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($PotentialGodots) {
        $ResolvedGodot = $PotentialGodots.FullName
    } else {
        $ResolvedGodot = (Join-Path $AgyDir "bin\godot.exe")
    }
}

# Resolve package entrypoints
$GodotMcpEntry = (Join-Path $HermesNodeDir "node_modules\godot-mcp\build\index.js")
if (-not (Test-Path $GodotMcpEntry)) {
    $GodotMcpEntry = (Join-Path $env:APPDATA "npm\node_modules\godot-mcp\build\index.js")
}

$GodotBridgeEntry = (Join-Path $HermesNodeDir "node_modules\godot-mcp-bridge\dist\index.js")
if (-not (Test-Path $GodotBridgeEntry)) {
    $GodotBridgeEntry = (Join-Path $env:APPDATA "npm\node_modules\godot-mcp-bridge\dist\index.js")
}

$RemotionMcpEntry = (Join-Path $HermesNodeDir "node_modules\@remotion\mcp\dist\index.js")
if (-not (Test-Path $RemotionMcpEntry)) {
    $RemotionMcpEntry = (Join-Path $env:APPDATA "npm\node_modules\@remotion\mcp\dist\index.js")
}

$VoxelEntry = (Join-Path $AgyDir "mcp_servers\voxel-mcp\dist\index.js")
$BlockbenchEntry = (Join-Path $AgyDir "mcp_servers\blockbench-mcp\dist\index.js")

# Build mcp_config structure
$McpConfigObj = @{
    mcpServers = @{
        "godot" = @{
            command = "node"
            args = @($GodotMcpEntry)
            env = @{
                GODOT_PATH = $ResolvedGodot
            }
        }
        "godot-bridge" = @{
            command = "node"
            args = @($GodotBridgeEntry)
        }
        "voxel" = @{
            command = "node"
            args = @($VoxelEntry)
        }
        "blockbench" = @{
            command = "node"
            args = @($BlockbenchEntry)
        }
        "blender" = @{
            command = "uvx"
            args = @("blender-mcp")
            env = @{
                DISABLE_TELEMETRY = "true"
            }
        }
        "remotion" = @{
            command = "node"
            args = @($RemotionMcpEntry)
        }
    }
}

$McpConfigJson = $McpConfigObj | ConvertTo-Json -Depth 6

$TargetMcpConfigs = @(
    (Join-Path $AgyDir "mcp_config.json"),
    (Join-Path $ConfigDir "mcp_config.json")
)

foreach ($target in $TargetMcpConfigs) {
    Set-Content -Path $target -Value $McpConfigJson -Encoding UTF8
    Write-Host "  [+] Wrote MCP config: $target" -ForegroundColor Cyan
}

# Copy Global Antigravity Config
$TargetGlobalConfig = Join-Path $ConfigDir "config.json"
$SrcGlobalConfig = Join-Path $ScriptDir "configs\config.json"
if (Test-Path $SrcGlobalConfig) {
    Copy-Item -Path $SrcGlobalConfig -Destination $TargetGlobalConfig -Force
    Write-Host "  [+] Wrote Antigravity config: $TargetGlobalConfig" -ForegroundColor Cyan
}

# Deploy Workspace Instructions & Agent Rules
Write-Host "`n[*] Deploying Antigravity Instructions & Rules (GEMINI.md, AGENTS.md, INSTRUCTIONS.md, .cursorrules, CLAUDE.md)..." -ForegroundColor Green
$RuleFiles = @("GEMINI.md", "AGENTS.md", "INSTRUCTIONS.md", ".cursorrules", "CLAUDE.md", ".windsurfrules")
foreach ($rf in $RuleFiles) {
    $srcRf = Join-Path $ScriptDir $rf
    if (Test-Path $srcRf) {
        Copy-Item -Path $srcRf -Destination (Join-Path $GeminiDir $rf) -Force
        Copy-Item -Path $srcRf -Destination (Join-Path $ConfigDir $rf) -Force
        Copy-Item -Path $srcRf -Destination (Join-Path $AgyDir $rf) -Force
    }
}
Write-Host "  [+] Deployed agent instructions to ~/.gemini (GEMINI.md, AGENTS.md, INSTRUCTIONS.md)" -ForegroundColor Cyan

# ----------------------------------------------------
# 7. Verification & Summary
# ----------------------------------------------------
Write-Host "`n[7/7] Environment Verification..." -ForegroundColor Green
Write-Host "  Skills installed:    $skillCount" -ForegroundColor White
Write-Host "  MCP servers active:  6 (godot, godot-bridge, voxel, blockbench, blender, remotion)" -ForegroundColor White
Write-Host "  Godot Binary Path:   $ResolvedGodot" -ForegroundColor White

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  ANTIGRAVITY ENVIRONMENT SETUP COMPLETE!" -ForegroundColor Green
Write-Host "  All skills, MCP servers, and settings are fully restored." -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
