# Blockworld MCP Server

A live voxel world MCP server with 100 materials, geometric primitives, and a real-time line-art 3D web viewer.

## Available Tools
- world_info: Get block physical scale and proportions reference
- list_materials: List all 100 material names
- place_block: Place individual voxel (detail only)
- place_box: Place solid or hollow rectangular prism
- place_cylinder: Place cylinder along axis
- place_cone: Place cone along axis
- place_sphere: Place solid or hollow sphere
- place_tube: Place 3D tube/curve through spline points
- mirror: Mirror voxels across plane
- remove_block: Remove single block
- remove_box: Remove rectangular volume of blocks
- clear: Reset world
- describe_world: Summary of placed blocks

## Live Viewer
To view creations in real time:
```bash
cd C:\Users\Administrator\.gemini\antigravity\mcp_servers\blockworld
npx --yes serve . -p 5173
```
Open http://localhost:5173/viewer/ in your browser.
