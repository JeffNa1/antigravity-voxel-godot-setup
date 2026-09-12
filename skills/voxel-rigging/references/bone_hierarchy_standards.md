# Bone Hierarchy & Naming Standards

## Godot 4 / glTF Humanoid Compatibility
To ensure animations retarget cleanly across characters in Godot 4 (using `SkeletonProfileHumanoid`):

| Bone Name (Standard) | Blender Name | Godot Humanoid Target | Description |
| :--- | :--- | :--- | :--- |
| `Root` | `Root` | `Root` | Base on the ground (0,0,0) |
| `Hips` | `Hips` | `Hips` | Pelvis / Root motion bone |
| `Spine` | `Spine` | `Spine` | Lower torso |
| `Chest` | `Chest` | `Chest` | Upper torso / ribcage |
| `Neck` | `Neck` | `Neck` | Neck connector |
| `Head` | `Head` | `Head` | Head cube |
| `UpperArm.L` / `.R` | `UpperArm.L` | `LeftUpperArm` / `RightUpperArm` | Shoulder to elbow |
| `LowerArm.L` / `.R` | `LowerArm.L` | `LeftLowerArm` / `RightLowerArm` | Elbow to wrist |
| `Hand.L` / `.R` | `Hand.L` | `LeftHand` / `RightHand` | Voxel hand / weapon attach |
| `UpperLeg.L` / `.R` | `UpperLeg.L` | `LeftUpperLeg` / `RightUpperLeg` | Hip to knee |
| `LowerLeg.L` / `.R` | `LowerLeg.L` | `LeftLowerLeg` / `RightLowerLeg` | Knee to ankle |
| `Foot.L` / `.R` | `Foot.L` | `LeftFoot` / `RightFoot` | Foot base on ground |
