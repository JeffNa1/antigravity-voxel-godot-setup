---
name: voxel-godot-pipeline
description: >-
  End-to-end integration and workflow for importing, configuring, and scripting voxel models,
  rigs, and animations inside Godot Engine 4.x. Covers pixel-crisp texture import settings,
  CharacterBody3D movement, AnimationPlayer / AnimationTree state machines, and GridMap mesh libraries.
---

# Voxel Godot 4 Pipeline Skill

This skill guides the complete setup of voxel assets, characters, and environments in Godot Engine 4.x.

---

## 1. Importing Voxel Models (.glb / .gltf)

### Texture Crispness (Point / Nearest Filtering)
By default, Godot applies linear texture filtering, which blurs low-resolution voxel palette textures.
To fix:
1. In the **FileSystem** dock, select the imported `.glb` or texture `.png`.
2. Go to the **Import** dock.
3. Under **Materials**, set default texture filter to `Nearest` or configure in StandardMaterial3D:
   - `Texture -> Filter`: **Nearest** (`TEXTURE_FILTER_NEAREST`).
4. Under **Meshes**:
   - Set `Light Baking`: **Static** (for environment props) or **Disabled** (for dynamic characters).
5. Click **Reimport**.
- See [import_settings_guide.md](./references/import_settings_guide.md).

---

## 2. Setting Up a Voxel Character (CharacterBody3D)

### Scene Node Hierarchy:
```text
CharacterBody3D (VoxelPlayer)
├── CollisionShape3D (BoxShape3D or CapsuleShape3D)
├── VisualPivot (Node3D)
│   └── VoxelModelInstance (MeshInstance3D / Skeleton3D / Armature)
└── AnimationPlayer / AnimationTree
```

### Collision Shape Best Practice
- Use `BoxShape3D` or `CapsuleShape3D`.
- Keep the collision bottom slightly above the lowest voxel foot boundary (by `0.02m`) to prevent catching on small floor voxel seams.

---

## 3. Character Controller & State Machine

- Production-grade GDScript for full 3D voxel locomotion, jumping, gravity, rotation smoothing, and animation transitions:
  - Read [godot4_character_controller.gd](./references/godot4_character_controller.gd).

---

## 4. GridMap Voxel World Building

- Convert voxel modular tiles into a `MeshLibrary` for 3D GridMap placement:
  - Script: [generate_gridmap_meshlib.gd](./scripts/generate_gridmap_meshlib.gd).
