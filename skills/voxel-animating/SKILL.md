---
name: voxel-animating
description: >-
  Principles and step-by-step procedures for animating voxel characters, creatures, and props.
  Covers keyframing, stepped/stop-motion vs smooth interpolation, walk/run/idle/jump cycles,
  secondary motion, and Godot 4 AnimationPlayer / AnimationTree integration.
---

# Voxel Animation Skill

Voxel animation has a unique charm that blends traditional stop-motion aesthetics with modern game physics.

---

## 1. Voxel Animation Aesthetics

### Interpolation Choices
1. **Stepped / Constant Interpolation (Stop-Motion / Retro Style)**:
   - Keyframes jump instantaneously between poses.
   - Typically animated on 2s or 3s (10 fps to 15 fps keyframe updates on a 30/60 fps timeline).
   - Gives the classic Minecraft / Crossy Road toy-like feel.
2. **Linear Interpolation**:
   - Crisp mechanical movements with sharp direction changes.
3. **Smooth / Bezier Interpolation**:
   - Used for fluid action or modern voxel games (e.g., The Sandbox, Cube World).
- Read [interpolation_styles.md](./references/interpolation_styles.md) for configuring curve modes in Blender and Godot.

---

## 2. Core Locomotion Cycles

### Idle Cycle (Duration: 1.6s - 2.0s, Looping)
- **Hips**: Subtle Y-axis bobbing (down 0.5-1 voxel, then return).
- **Chest / Spine**: Slight breathing expansion (subtle forward rotation of 2-3 degrees).
- **Head**: Counter-rotates slightly to keep eyes level with the horizon.
- **Arms**: Gentle swaying offset by 0.2s from chest movement.

### Walk Cycle (Duration: 0.8s - 1.0s, Looping)
- 4 Key Poses:
  1. **Contact Pose (Frame 0 & 12)**: Leading heel strikes ground; trailing toe pushing off; opposite arm swings forward.
  2. **Down / Recoil Pose (Frame 3 & 15)**: Lowest body height (hips sink 1 voxel); weight on front foot; knees bent.
  3. **Passing Pose (Frame 6 & 18)**: Trailing leg swings past standing leg; body rises; standing leg straightens.
  4. **Up / High Point (Frame 9 & 21)**: Highest body height; back foot leaves ground.
- Frame-by-frame guide: [animation_cycles_cheatsheet.md](./references/animation_cycles_cheatsheet.md).

### Run Cycle (Duration: 0.5s - 0.6s, Looping)
- Faster pacing, deeper forward torso lean (15-25 degrees).
- Clear airborne / flight phase where both feet leave the ground.
- Wider arm swing arc (-45 to +50 degrees).

### Jump Cycle (3 Parts)
1. **Anticipation (Takeoff)**: Character crouches down 2-3 voxels (0.1s - 0.15s).
2. **Apex (In-Air)**: Arms raised, legs tucked up; hold pose until downward velocity begins.
3. **Landing**: Deep squash on touchdown, followed by rapid recovery to idle/run.

---

## 3. Secondary Animation for Voxel Characters
- **Rigid Accessories**: Hats, backpacks, shields should bounce on a 1-to-2 frame delay.
- **Hair / Capes**: Keyframe in stepped arcs to mimic physical momentum without mesh distortion.
