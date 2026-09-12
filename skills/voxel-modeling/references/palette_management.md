# Voxel Palette Management & Texture Atlasing

## Color Palette Strategies
1. **Classic 256-Color Palette (MagicaVoxel style)**:
   - Dimensions: 256x1 pixels or 16x16 pixels.
   - Each voxel color maps directly to an index `0..255`.
2. **UV Coordinate Calculation**:
   - For a 256x1 texture:
     `U = (index + 0.5) / 256.0`
     `V = 0.5`
   - Adding `0.5` samples from the exact pixel center, avoiding texture filtering artifacts.
3. **Texture Settings in Game Engine**:
   - Texture Filter: **Nearest** (Godot: `TextureFilter.TEXTURE_FILTER_NEAREST`).
   - Mipmaps: Disabled (or generated with nearest-neighbor sampling).
   - Color Space: sRGB for Albedo.

## Material Channels
- **Albedo**: Color palette index map.
- **Roughness & Metallic**: Can be mapped via secondary palette textures or per-vertex color alpha.
- **Emission**: Use dedicated index ranges for glowing voxels (lava, neon lights, glowing eyes).
