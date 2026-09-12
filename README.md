# 🌌 Antigravity 2.0 Voxel & Godot Environment Kit

[![Antigravity 2.0](https://img.shields.io/badge/Antigravity-2.0-blueviolet?style=for-the-badge&logo=google)](https://github.com/JeffNa1/antigravity-voxel-godot-setup)
[![Godot Engine](https://img.shields.io/badge/Godot-4.x-478CBF?style=for-the-badge&logo=godotengine&logoColor=white)](https://godotengine.org/)
[![Remotion](https://img.shields.io/badge/Remotion-Video%20Code-0B84FF?style=for-the-badge&logo=react)](https://www.remotion.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![PowerShell](https://img.shields.io/badge/PowerShell-7%2F5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://microsoft.com/powershell)

> **All-in-one portable environment configuration, MCP servers, and specialized skills for Google Antigravity 2.0.**  
> Effortlessly reproduce your entire 3D Voxel modeling, Godot 4 game dev pipeline, and Remotion video studio in a single command on any machine or session.

---

## ⚡ Quick Start (1-Click Bootstrap)

Whenever you start a fresh session or switch to a new workstation, run this single line in **PowerShell**:

```powershell
irm https://raw.githubusercontent.com/JeffNa1/antigravity-voxel-godot-setup/main/bootstrap.ps1 | iex
```

### Manual Installation

```powershell
git clone https://github.com/JeffNa1/antigravity-voxel-godot-setup.git
cd antigravity-voxel-godot-setup
.\install.ps1
```

### System Verification

After installation, verify that all skills, configurations, and MCP servers are functional:

```powershell
.\verify.ps1
```

---

## 🏗️ What's Included

### 1. 🔌 6 MCP Servers (Model Context Protocol)

| Server | Type | Description | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **`godot`** | Node.js | Headless Godot 4 CLI integration | Scene testing, script validation, shader compilation |
| **`godot-bridge`** | Node.js / TCP | Live runtime Godot Editor bridge | `scene_tree_dump`, `add_node`, `connect_signal`, screenshots |
| **`voxel`** | TypeScript | Procedural 3D Voxel Engine | `.vox`, `.obj`, `.gltf` export, palette swap, mesh optimization |
| **`blockbench`** | TypeScript | Low-poly & Voxel Modeling Automation | Cubes, UV atlas, bone hierarchies, keyframe animation |
| **`blender`** | Python / uvx | Headless Blender 4 automation | Python scripting, Polyhaven & Sketchfab asset imports |
| **`remotion`** | Node.js | Video-as-code automation | Remotion API documentation, project scaffolds |

---

### 2. 🧠 22 Specialized Antigravity Skills

#### 🎲 Voxel & Game Development (5 Skills)
- `voxel-modeling` — 3D voxel creation, topology optimization, MagicaVoxel palette curation.
- `voxel-rigging` — Skeletal hierarchy, 100% rigid weight-painting, pivot points for blocky characters.
- `voxel-animating` — Keyframing, walk cycles, breathing idles, attack combos, state blends.
- `voxel-godot-pipeline` — Godot 4 pixel-crisp texture import, CharacterBody3D, AnimationTree, GridMap.
- `blockbench-pipeline` — Blockbench modeling, UV unwrap, bone groups, glTF export workflow.

#### 🎬 Remotion Programmatic Video (12 Skills)
- `remotion-best-practices` — Architectural master guide for React/Remotion video design.
- `remotion-create` — Fast scaffolding for new video projects with Tailwind & TypeScript.
- `remotion-render` — CLI rendering with hardware-accelerated ffmpeg, bitrate, & codec tuning.
- `remotion-studio` — Browser-based real-time preview and timeline scrubber.
- `remotion-markup` — Springs, interpolations, animated typography, and camera movements.
- `remotion-interactivity` — Dynamic and parameter-driven video composition.
- `remotion-captions` — Automated captions, kinetic pixel subtitles, and audio syncing.
- `remotion-multimedia` — Mediabunny audio-video compositing, volume leveling, sound FX.
- `remotion-maps` — High-fidelity animated map visualization.
- `remotion-saas` — Headless video generation server architectures.
- `remotion-docs` — Up-to-date Remotion documentation index.
- `remotion-upgrade` — Dependency migration and package upgrade workflows.

#### ⚙️ Antigravity Core & Utilities (5 Skills)
- `agy-customizations` — Full reference for crafting Skills, Rules, Hooks, Plugins, and MCP servers.
- `antigravity-guide` — Complete user handbook for Antigravity IDE, CLI, slash commands, and hotkeys.
- `generative_ui` — Rendering inline interactive HTML/CSS widgets and canvas previews.
- `migrate-workflows` — Automated conversion from legacy agent workflows to modern SKILL.md.

---

## 📂 Repository Layout

```
antigravity-voxel-godot-setup/
├── configs/
│   ├── config.json             # Global Antigravity engine settings
│   └── mcp_config.json         # MCP server registry template
├── mcp/                        # Lazy-loaded tool schemas (JSON)
│   ├── blender/
│   ├── blockbench/
│   ├── godot-bridge/
│   ├── remotion/
│   └── voxel/
├── mcp_servers/                # Source code & runners for custom MCP tools
│   ├── voxel-mcp/              # TypeScript procedural voxel server
│   └── blockbench-mcp/         # TypeScript Blockbench automation server
├── skills/                     # 22 Ready-to-use Antigravity Skills
│   ├── voxel-*/
│   ├── remotion-*/
│   └── ...
├── bootstrap.ps1               # 1-line curl/irm web installer
├── install.ps1                 # Full Windows setup script with path substitution
├── install.sh                  # Linux / WSL setup script
├── verify.ps1                  # Diagnostic check script
├── setup.md                    # Deep-dive architecture & manual setup documentation
└── README.md                   # Repository overview
```

---

## 🛠️ Dynamic Path Resolution

The installer automatically detects your active Windows user profile (`$env:USERPROFILE`) and dynamically replaces absolute paths inside `mcp_config.json`. This ensures that:
- You will never encounter `Path not found` or `Access Denied` errors.
- It works seamlessly across different usernames (e.g. `Administrator`, `John`, `DevUser`).
- All MCP tools point to the correct local paths in `~/.gemini/antigravity/mcp_servers/`.

---

## 📖 Complete Documentation

For detailed step-by-step setup, troubleshooting, and architectural guides, see [setup.md](setup.md).

---

## 📜 License

MIT License © 2026 [JeffNa1](https://github.com/JeffNa1)
