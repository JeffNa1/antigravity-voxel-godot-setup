# Blockbench MCP Server — Instructions & Best Practices

## Overview
The `blockbench` MCP server automates Blockbench low-poly and voxel asset modeling, bone hierarchy structuring, UV atlas texturing, and keyframe animations.

## Key Capabilities
- **Project Setup**: `new_project`, `set_project_meta`, `load_project`, `save_project`, `export_model`.
- **Geometry Operations**: `add_cube`, `add_cubes`, `add_group`, `voxelize_matrix`, `extrude_chain`.
- **Texturing & UV**: `create_texture`, `apply_texture`, `pack_uv`, `paint_texture`, `set_cube_uv`.
- **Rigging & Bones**: `create_rig`, `check_rig`, `get_rig`.
- **Animation**: `create_animation`, `add_keyframe`, `add_keyframes`, `generate_animation`, `preview_animation`.

## Best Practices
1. **Bone Hierarchy**: Group cubes logically into bones (`root` -> `hips` -> `spine` -> `chest` -> `head`, `arm_l`, `arm_r`, `leg_l`, `leg_r`).
2. **Pivot Placement**: Always set pivot coordinates at the exact socket joint before creating animations.
3. **Rigid Weighting**: Voxel models rely on 100% rigid binding (each cube belongs entirely to one parent bone). Do not apply soft skinning.
4. **UV Atlas Packing**: Always run `pack_uv` after adding or resizing cubes to prevent overlapping texture faces.
5. **Export Format**: Use `export_model` with `gltf` format for direct compatibility with Godot Engine 4.
