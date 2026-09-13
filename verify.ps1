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
        Write-Host "  [+] $Title" -ForegroundColor Green
        if ($Detail) { Write-Host "      $Detail" -ForegroundColor DarkGray }
    } else {
        Write-Host "  [x] $Title" -ForegroundColor Red
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
$ghVer = if ($ghCmd) { (gh --version | Select-Object -First 1) } else { "" }
Print-Check -Title "GitHub CLI (gh)" -Success ([bool]$ghCmd) -Detail $ghVer

$godotBin = if (Get-Command godot -ErrorAction SilentlyContinue) { (Get-Command godot).Source } elseif (Test-Path (Join-Path $AgyDir "bin\godot.exe")) { (Join-Path $AgyDir "bin\godot.exe") } else { $null }
$hasGodot = [bool]$godotBin -and (Test-Path $godotBin)
$godotVer = ""
if ($hasGodot) {
    try {
        $tempVerFile = Join-Path $env:TEMP "godot_vcheck.txt"
        Start-Process -FilePath $godotBin -ArgumentList "--headless --version" -NoNewWindow -Wait -RedirectStandardOutput $tempVerFile -ErrorAction SilentlyContinue
        if (Test-Path $tempVerFile) {
            $godotVer = (Get-Content $tempVerFile -Raw).Trim()
            Remove-Item $tempVerFile -Force -ErrorAction SilentlyContinue
        }
    } catch {}
}
Print-Check -Title "Godot Engine 4 (godot.exe)" -Success $hasGodot -Detail $(if ($godotVer) { "$godotVer ($godotBin)" } else { $godotBin })

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
$BlockworldDist = Join-Path $AgyDir "mcp_servers\blockworld\server.js"
Print-Check -Title "voxel-mcp built binary" -Success (Test-Path $VoxelDist) -Detail $VoxelDist
Print-Check -Title "blockbench-mcp built binary" -Success (Test-Path $BlockbenchDist) -Detail $BlockbenchDist
Print-Check -Title "blockworld server binary" -Success (Test-Path $BlockworldDist) -Detail $BlockworldDist

Write-Host "`n--- 5. GLOBAL CONFIGURATION ---" -ForegroundColor Yellow
$GlobalCfg = Join-Path $ConfigDir "config.json"
Print-Check -Title "config.json (Turbo & Auto-execution)" -Success (Test-Path $GlobalCfg) -Detail $GlobalCfg

$ProjectCfg = Join-Path $ConfigDir "projects\outside-of-project.json"
Print-Check -Title "outside-of-project.json (Project policy)" -Success (Test-Path $ProjectCfg) -Detail $ProjectCfg

$StatePbtxt = Join-Path $AgyDir "antigravity_state.pbtxt"
Print-Check -Title "antigravity_state.pbtxt (Onboarding bypass)" -Success (Test-Path $StatePbtxt) -Detail $StatePbtxt

Write-Host "`n--- 6. WORKSPACE RULES & INSTRUCTIONS ---" -ForegroundColor Yellow
$GeminiMd = Join-Path $GeminiDir "GEMINI.md"
$AgentsMd = Join-Path $GeminiDir "AGENTS.md"
Print-Check -Title "Agent Instructions (GEMINI.md)" -Success (Test-Path $GeminiMd) -Detail $GeminiMd
Print-Check -Title "Agent Rules (AGENTS.md)" -Success (Test-Path $AgentsMd) -Detail $AgentsMd

$McpInstructionCount = (Get-ChildItem (Join-Path $AgyDir "mcp") -Filter "instructions.md" -Recurse -ErrorAction SilentlyContinue).Count
Print-Check -Title "MCP Instructions ($McpInstructionCount/5 servers)" -Success ($McpInstructionCount -ge 4) -Detail "mcp/**/instructions.md"

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  VERIFICATION COMPLETE" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
