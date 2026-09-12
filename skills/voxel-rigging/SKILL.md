---
name: voxel-rigging
description: >-
  Techniques and procedures for rigging voxel and blocky 3D models, setting up bone hierarchies,
  pivot points, rigid weight painting (100% per-limb weighting), inverse kinematics (IK), and glTF
  exporting for game engines (Godot, Unity). Use when creating skeletons, setting up armatures,
  or binding meshes for voxel characters and creatures.
---

# Voxel Character Rigging Skill

Rigging voxel models has distinct requirements compared to organic/smooth models:
- Voxel models require **rigid 100% vertex weights** (no soft blending) to preserve crisp geometric silhouettes without rubbery distortion.
- Joint pivot locations must align precisely with the voxel grid or limb boundaries.

---

## 1. Golden Rules of Voxel Rigging

### Rule 1: Rigid Weight Assignment (1.0 Weight)
- Each individual voxel cube or mesh segment must belong to **exactly one bone** with a weight of `1.0`.
- Do NOT use automatic smooth weights ("With Automatic Weights" in Blender) directly without post-processing, as it creates soft deformations that stretch voxel cubes.

### Rule 2: Pivot Point Grid Alignment
- Pivot points must be centered along the joint rotational axis and aligned with voxel edges:
  - **Knees / Elbows**: Placed at the top or hinge line of the lower limb.
  - **Shoulders**: Placed at the upper corner inside the arm connecting to the torso.
  - **Head**: Placed at the neck base center `(X=0, Y=torso_top, Z=torso_center)`.

### Rule 3: Gap & Overlap Management
- Design joints with a 1-voxel overlap or rounded joint cap to prevent visible hollow holes when limbs bend.
- Alternatively, use separate detached limb meshes parented directly to bones.

---

## 2. Standard Humanoid Bone Hierarchy

```text
Root (Origin 0,0,0)
└── Pelvis / Hips
    ├── Spine
    │   └── Chest
    │       ├── Neck
    │       │   └── Head
    │       ├── Shoulder.L -> UpperArm.L -> LowerArm.L -> Hand.L
    │       └── Shoulder.R -> UpperArm.R -> LowerArm.R -> Hand.R
    ├── UpperLeg.L -> LowerLeg.L -> Foot.L
    └── UpperLeg.R -> LowerLeg.R -> Foot.R
```

Detailed bone naming rules for Godot 4 compatibility: see [bone_hierarchy_standards.md](./references/bone_hierarchy_standards.md).

---

## 3. Blender Rigging Workflow

1. Model each limb as a separate object or keep them as distinct polygroups.
2. Add Armature (`Single Bone`), name it `Root`.
3. In Edit Mode, extrude and position bones according to the standard hierarchy.
4. Select all Mesh Objects, then select Armature -> `Ctrl+P` -> **Parent With Empty Groups**.
5. Select each body part in Edit Mode, select its corresponding Vertex Group in the Object Data tab, and click **Assign** with Weight `1.000`.
6. Add IK constraints for legs and arms if needed for animation.

Detailed Blender steps: [blender_voxel_rigging.md](./references/blender_voxel_rigging.md).
Automation script: [auto_rig_voxel_humanoid.py](./scripts/auto_rig_voxel_humanoid.py).
