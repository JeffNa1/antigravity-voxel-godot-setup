---
name: voxel-modeling
description: >-
  Comprehensive guide and procedures for voxel 3D modeling, asset creation, mesh optimization,
  palette management, and export workflows for games. Use when creating, editing, or optimizing
  voxel assets using MagicaVoxel, Blockbench, Blender, or procedural voxel generators.
---

# Voxel 3D Modeling Skill

This skill provides full technical instructions for creating, structuring, and optimizing voxel 3D assets for real-time game engines like Godot, Unity, and Unreal.

---

## Core Modeling Principles

### 1. Grid & Scale Standardization
- **Metric Unit Scale**: Standardize `1 voxel = 0.0625m (1/16m)` or `1 voxel = 0.1m`.
- **Character Baseline**: Standard humanoid character height is typically `24 to 32 voxels` tall (e.g. 30 voxels at 0.0625m = 1.875m).
- **Proportions**:
  - Head: 8x8x8 or 10x10x10 voxels
  - Torso: 8x4x12 or 8x6x12 voxels
  - Limbs: 4x4x12 voxels
- **Snapping**: Always snap voxel boundaries to integers on the grid to ensure sharp edges and seamless geometry.

### 2. Modeling Software Workflows
- **Blockbench**:
  - Best for: Rigged low-poly characters, modular assets, Minecraft-style entities.
  - Recommended Format: `.bbmodel` (source), export to `.gltf`/`.glb`.
  - Use "Generic Model" project type for non-Minecraft games.
- **MagicaVoxel**:
  - Best for: High-density voxel dioramas, environment props, organic voxel art.
  - Native format: `.vox`.
  - Export format: `.obj` (with palette png) or `.vox` into Blender for retopology.
- **Blender Voxel Workflow**:
  - Remeshing high-poly meshes using the **Voxel Remesh** modifier.
  - Snapping to 3D grid and using geometry nodes / python scripts.

---

## Mesh Optimization & Greedy Meshing

Raw voxel models contain internal faces and excessive polygon counts:
1. **Remove Occluded Faces**: Any face sharing a boundary with an adjacent solid voxel MUST be culled.
2. **Greedy Meshing**: Merge adjacent coplanar quad faces of the same material/color into larger single quads.
   - Reduces polygon count by 70% to 90%.
   - Reduces vertex count, draw calls, and memory footprint.
3. Refer to [greedy_meshing.md](./references/greedy_meshing.md) for algorithm details and implementation.

---

## Palette & Texture Management

- **Indexed Palette Texture**: Use a single 1D or 2D color palette image (e.g. 256x1 or 16x16 PNG).
- **UV Mapping**: Map all faces of a specific color to the center of the matching pixel on the palette image (`u = (color_index + 0.5) / palette_width, v = 0.5`).
- **Filtering**: Set texture sampling to **Nearest / Point** (no bilinear smoothing) to prevent color bleeding across pixel seams.
- Read [palette_management.md](./references/palette_management.md) for full palette pipelines.

---

## Scripts & Automation
- Model optimization script: [voxel_optimizer.py](./scripts/voxel_optimizer.py)
