Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  VERIFYING ANTIGRAVITY ENVIRONMENT STATUS" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$UserHome = $env:USERPROFILE
$GeminiDir = Join-Path $UserHome ".gemini"
$AgyDir = Join-Path $GeminiDir "antigravity"
$ConfigDir = Join-Path $GeminiDir "config"

function Print-Check {
    param(
        [string]$Title,
        [bool]$Success,
        [string]$Detail
    )
    if ($Success) {
        Write-Host "  [✓] $Title" -ForegroundColor Green
        if ($Detail) { Write-Host "      $Detail" -ForegroundColor DarkGray }
    } else {
        Write-Host "  [✗] $Title" -ForegroundColor Red
        if ($Detail) { Write-Host "      $Detail" -ForegroundColor Yellow }
    }
}

Write-Host "`n--- 1. TOOLCHAIN & BINARIES ---" -ForegroundColor Yellow

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
$nodeVer = if ($nodeCmd) { (node -v) } else { "" }
Print-Check -Title "Node.js" -Success ([bool]$nodeCmd) -Detail $nodeVer

$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
$npmVer = if ($npmCmd) { (npm -v) } else { "" }
Print-Check -Title "npm" -Success ([bool]$npmCmd) -Detail $npmVer

$uvCmd = Get-Command uv -ErrorAction SilentlyContinue
$pyCmd = Get-Command python -ErrorAction SilentlyContinue
$hasPy = ([bool]$uvCmd) -or ([bool]$pyCmd)
Print-Check -Title "Python / UV" -Success $hasPy -Detail "Python / UV available"

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
$gitVer = if ($gitCmd) { (git --version) } else { "" }
Print-Check -Title "Git CLI" -Success ([bool]$gitCmd) -Detail $gitVer

$ghCmd = Get-Command gh -ErrorAction SilentlyContinue
Print-Check -Title "GitHub CLI (gh)" -Success ([bool]$ghCmd) -Detail "gh CLI available"

Write-Host "`n--- 2. ANTIGRAVITY SKILLS ---" -ForegroundColor Yellow
$SkillsConfig = Join-Path $ConfigDir "skills"
$SkillsCount = 0
if (Test-Path $SkillsConfig) {
    $SkillsCount = (Get-ChildItem $SkillsConfig -Directory).Count
}
Print-Check -Title "Config Skills ($SkillsCount installed)" -Success ($SkillsCount -ge 15) -Detail $SkillsConfig

Write-Host "`n--- 3. MCP SERVERS CONFIGURATION ---" -ForegroundColor Yellow
$McpConfigFile = Join-Path $AgyDir "mcp_config.json"
$HasMcpConfig = Test-Path $McpConfigFile
Print-Check -Title "antigravity/mcp_config.json" -Success $HasMcpConfig -Detail $McpConfigFile

if ($HasMcpConfig) {
    try {
        $json = Get-Content $McpConfigFile -Raw | ConvertFrom-Json
        $servers = $json.mcpServers.PSObject.Properties.Name
        Write-Host "      Registered servers: $($servers -join ', ')" -ForegroundColor Cyan
    } catch {
        Write-Warning "Could not parse mcp_config.json"
    }
}

Write-Host "`n--- 4. CUSTOM MCP RUNNERS ---" -ForegroundColor Yellow
$VoxelDist = Join-Path $AgyDir "mcp_servers\voxel-mcp\dist\index.js"
$BlockbenchDist = Join-Path $AgyDir "mcp_servers\blockbench-mcp\dist\index.js"
Print-Check -Title "voxel-mcp built binary" -Success (Test-Path $VoxelDist) -Detail $VoxelDist
Print-Check -Title "blockbench-mcp built binary" -Success (Test-Path $BlockbenchDist) -Detail $BlockbenchDist

Write-Host "`n--- 5. GLOBAL CONFIGURATION ---" -ForegroundColor Yellow
$GlobalCfg = Join-Path $ConfigDir "config.json"
Print-Check -Title "config.json" -Success (Test-Path $GlobalCfg) -Detail $GlobalCfg

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  VERIFICATION COMPLETE" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
