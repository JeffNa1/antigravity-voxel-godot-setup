# Godot 4 Import Settings Guide for Voxel Assets

## 1. Project-Wide Default Texture Filter
To avoid configuring every texture individually:
1. Navigate to **Project Settings -> Rendering -> Textures -> Default Texture Filter**.
2. Change from `Linear` to **`Nearest`**.
3. All pixel art and voxel textures will automatically render crisp without blurring.

## 2. GLTF Model Import Settings
In the Import dock for `.glb` files:
- **Root Type**: `Node3D` or `CharacterBody3D`.
- **Root Scale**: Ensure scale is `1.0, 1.0, 1.0`.
- **Skeleton Retargeting**: If using Humanoid bones, enable `Bone Map` and select `SkeletonProfileHumanoid`.
- **Animation Loop Mode**: Ensure `idle`, `walk`, and `run` have `Loop Mode` set to `Linear` or `Pingpong`.
