#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "  ANTIGRAVITY 2.0 VOXEL & GAME ENVIRONMENT SETUP (UNIX)  "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
GEMINI_DIR="$USER_HOME/.gemini"
AGY_DIR="$GEMINI_DIR/antigravity"
CONFIG_DIR="$GEMINI_DIR/config"

echo "[*] Target Home:   $USER_HOME"
echo "[*] Source:        $SCRIPT_DIR"

mkdir -p "$CONFIG_DIR/skills" "$AGY_DIR/skills" "$AGY_DIR/mcp" "$AGY_DIR/mcp_servers" "$AGY_DIR/bin"

echo "[1/4] Installing Antigravity skills..."
cp -r "$SCRIPT_DIR/skills/"* "$CONFIG_DIR/skills/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/skills/"* "$AGY_DIR/skills/" 2>/dev/null || true

echo "[2/4] Installing MCP schemas & instructions..."
cp -r "$SCRIPT_DIR/mcp/"* "$AGY_DIR/mcp/" 2>/dev/null || true

echo "[3/4] Setting up custom MCP servers..."
cp -r "$SCRIPT_DIR/mcp_servers/voxel-mcp" "$AGY_DIR/mcp_servers/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/mcp_servers/blockbench-mcp" "$AGY_DIR/mcp_servers/" 2>/dev/null || true

if [ -d "$AGY_DIR/mcp_servers/voxel-mcp" ]; then
    (cd "$AGY_DIR/mcp_servers/voxel-mcp" && npm install --silent && npm run build) || true
fi
if [ -d "$AGY_DIR/mcp_servers/blockbench-mcp" ]; then
    (cd "$AGY_DIR/mcp_servers/blockbench-mcp" && npm install --silent && npm run build) || true
fi

# Ensure Godot 4.x on Linux/Unix
if ! command -v godot &> /dev/null && [ ! -f "$AGY_DIR/bin/godot" ]; then
    echo "  [*] Godot 4 not found. Auto-downloading Godot 4.3 Stable (Linux x86_64)..."
    GODOT_URL="https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip"
    curl -sL -o /tmp/godot.zip "$GODOT_URL" || true
    if [ -f /tmp/godot.zip ]; then
        unzip -q -o /tmp/godot.zip -d /tmp/godot_extract 2>/dev/null || true
        cp /tmp/godot_extract/Godot* "$AGY_DIR/bin/godot" 2>/dev/null || true
        chmod +x "$AGY_DIR/bin/godot" 2>/dev/null || true
        rm -rf /tmp/godot.zip /tmp/godot_extract
        echo "  [+] Installed Godot 4.3 to $AGY_DIR/bin/godot"
    fi
fi

# Ensure GitHub CLI on Linux/Unix
if ! command -v gh &> /dev/null && [ ! -f "$AGY_DIR/bin/gh" ]; then
    echo "  [*] GitHub CLI not found. Downloading gh CLI..."
    GH_URL="https://github.com/cli/cli/releases/download/v2.100.0/gh_2.100.0_linux_amd64.tar.gz"
    curl -sL -o /tmp/gh.tar.gz "$GH_URL" || true
    if [ -f /tmp/gh.tar.gz ]; then
        tar -xzf /tmp/gh.tar.gz -C /tmp/ 2>/dev/null || true
        cp /tmp/gh_*/bin/gh "$AGY_DIR/bin/gh" 2>/dev/null || true
        chmod +x "$AGY_DIR/bin/gh" 2>/dev/null || true
        rm -rf /tmp/gh.tar.gz /tmp/gh_*
        echo "  [+] Installed GitHub CLI to $AGY_DIR/bin/gh"
    fi
fi

echo "[4/4] Copying configurations & instructions..."
mkdir -p "$CONFIG_DIR/projects"
cp -r "$SCRIPT_DIR/configs/projects/"* "$CONFIG_DIR/projects/" 2>/dev/null || true
cp "$SCRIPT_DIR/configs/config.json" "$CONFIG_DIR/config.json" 2>/dev/null || true
cp "$SCRIPT_DIR/configs/antigravity_state.pbtxt" "$AGY_DIR/antigravity_state.pbtxt" 2>/dev/null || true
touch "$CONFIG_DIR/.migrated" 2>/dev/null || true
cp "$SCRIPT_DIR/GEMINI.md" "$GEMINI_DIR/GEMINI.md" 2>/dev/null || true
cp "$SCRIPT_DIR/AGENTS.md" "$GEMINI_DIR/AGENTS.md" 2>/dev/null || true
cp "$SCRIPT_DIR/INSTRUCTIONS.md" "$GEMINI_DIR/INSTRUCTIONS.md" 2>/dev/null || true
cp "$SCRIPT_DIR/GEMINI.md" "$CONFIG_DIR/GEMINI.md" 2>/dev/null || true

echo "=========================================================="
echo "  SETUP COMPLETED! All skills and MCPs are installed."
echo "=========================================================="
