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

echo "[4/4] Copying configurations & instructions..."
cp "$SCRIPT_DIR/configs/config.json" "$CONFIG_DIR/config.json" 2>/dev/null || true
cp "$SCRIPT_DIR/GEMINI.md" "$GEMINI_DIR/GEMINI.md" 2>/dev/null || true
cp "$SCRIPT_DIR/AGENTS.md" "$GEMINI_DIR/AGENTS.md" 2>/dev/null || true
cp "$SCRIPT_DIR/INSTRUCTIONS.md" "$GEMINI_DIR/INSTRUCTIONS.md" 2>/dev/null || true
cp "$SCRIPT_DIR/GEMINI.md" "$CONFIG_DIR/GEMINI.md" 2>/dev/null || true

echo "=========================================================="
echo "  SETUP COMPLETED! All skills and MCPs are installed."
echo "=========================================================="
