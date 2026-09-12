# Blender MCP Server — Instructions & Best Practices

## Overview
The `blender` MCP server provides automated Python scripting and asset ingestion inside headless Blender 4.

## Key Capabilities
- **Script Execution**: `execute_blender_code` runs arbitrary Python scripts utilizing `bpy`.
- **Asset Integration**:
  - Polyhaven: `search_polyhaven_assets`, `download_polyhaven_asset` (PBR textures & HDRIs).
  - Sketchfab: `search_sketchfab_models`, `download_sketchfab_model` (Low-poly reference assets).
- **Scene Inspection**: `get_scene_info`, `get_object_info`, `get_viewport_screenshot`.

## Best Practices
1. **Python Script Safety**:
   - Always import `bpy`, `math`, `mathutils` inside code blocks.
   - Clear existing meshes (`bpy.ops.object.select_all(action='SELECT')`, `bpy.ops.object.delete()`) if generating a fresh scene from scratch.
2. **Telemetry**: Keep disabled (`DISABLE_TELEMETRY=true`).
3. **Materials**: Set Principled BSDF roughness to appropriate values for voxel/stylized models (roughness: 0.7 - 0.9, specular: 0.2).
