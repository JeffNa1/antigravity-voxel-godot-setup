# Voxel MCP Server — Instructions & Best Practices

## Overview
The `voxel` MCP server provides a high-performance procedural 3D voxel engine capable of creating, transforming, optimizing, and exporting voxel models in `.vox` (MagicaVoxel), `.obj`, and `.gltf` formats.

## Key Capabilities
- **Primitive Generation**: `fill_box`, `fill_sphere`, `fill_cylinder`, `fill_pyramid`, `fill_cone`, `fill_torus`.
- **Procedural Generators**: `generate_character`, `generate_weapon`, `generate_furniture`, `generate_terrain`, `generate_structure`.
- **Transforms & Modifiers**: `transform_translate`, `transform_rotate90`, `scale_model`, `center_model`, `align_to_ground`, `boolean_op`.
- **Optimization & Topology**: `deduplicate_voxels`, `hollow_model`, `smooth_model`, `erode`, `dilate`.
- **Palette Management**: `extract_palette_from_image`, `apply_palette_to_model`, `replace_color`, `set_palette_index`.

## Best Practices
1. **Coordinate System**: Uses standard Y-up 3D space (`X` = width, `Y` = vertical height, `Z` = depth).
2. **Model Lifecycle**: Initialize with `create_model(width, height, depth)`. Use `save_vox` or `export_gltf` when completed.
3. **Memory & Performance**:
   - Keep canvas sizes bounded (standard character: 32x32x32 or 64x64x64).
   - Use `crop_to_content` before saving to trim empty bounding space.
   - Use `hollow_model` for large structures to eliminate internal occluded voxels.
