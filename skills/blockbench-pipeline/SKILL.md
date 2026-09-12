---
name: blockbench-pipeline
description: >-
  Workflows, best practices, and integration procedures for Blockbench: voxel/low-poly modeling,
  bone group structuring, UV atlas texturing, keyframe animation, and glTF export for Godot 4.
  Use when modeling or animating low-poly/voxel models using Blockbench.
---

# Blockbench 3D Voxel Pipeline Skill

Blockbench is a specialized 3D modeler and animator for blocky, voxel, and low-poly art.

---

## 1. Project Creation & Setup

### Project Format Selection
- For general game development (Godot, Unity): Always choose **Generic Model** (or **Low Poly Model**).
- Avoid Minecraft-specific presets (Java Block/Item, Bedrock Entity) unless targeting Minecraft mods, as they constrain bone formats.

---

## 2. Modeling & Pivot Points

### Snapping & Grid Settings
- Set Grid Resolution to `16` or `32` per block.
- Enable `Snap to Grid` to maintain clean integer coordinate alignments.

### Bone Groups & Pivot Placement
- In Blockbench, bones are represented as **Groups**.
- Every limb or animated piece must be placed inside a Group folder.
- Use the **Pivot Tool (`P`)** to position the group's pivot point:
  - Pivot must sit at the exact joint location (e.g. top of the arm, top of the leg, bottom of the neck).
  - Test rotation by selecting the group and rotating on X, Y, Z.

---

## 3. UV Mapping & Texture Atlas

1. Create a texture with power-of-two dimensions (e.g., `128x128` or `256x256`).
2. Use **Auto UV** or manually lay out cube faces.
3. Keep pixel density uniform across all cubes (e.g., 16 pixels per block meter).
4. Paint textures directly in the **Paint** tab using palette colors.

---

## 4. Animating in Blockbench

1. Switch to the **Animate** tab.
2. Create animations with standard names: `idle`, `walk`, `run`, `jump`, `attack`.
3. Set **Loop Mode**:
   - `Loop` for idle, walk, run.
   - `Play Once` for jump, attack, hurt.
4. Interpolation:
   - Choose `Step` for retro/stop-motion.
   - Choose `Linear` for crisp game animations.

---

## 5. Exporting for Godot 4

1. Go to **File -> Export -> Export glTF**.
2. Export as `.glb` (glTF Binary) or `.gltf`.
3. In export options:
   - Include Animations: **Yes**
   - Include Armature: **Yes**
4. Copy the `.glb` file directly into your Godot project folder.
