# Animation Cycles Cheatsheet for Voxel Characters

## Standard 24-Frame Walk Cycle (60 FPS = 0.8s)

| Frame | Hips Y | Hips Tilt | Left Leg | Right Leg | Left Arm | Right Arm |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **0** (Contact) | Base | 0° | +30° (Fwd) | -25° (Back) | -25° (Back) | +30° (Fwd) |
| **3** (Down) | -1 vox | -2° (L) | +15° | -30° (Toe) | -15° | +20° |
| **6** (Passing)| +0.5 vox| 0° | 0° (Straight)| +20° (Bending)| 0° | 0° |
| **9** (Up) | +1 vox | +2° (R) | -15° | +35° (Lifting)| +15° | -20° |
| **12** (Contact)| Base | 0° | -25° (Back) | +30° (Fwd) | +30° (Fwd) | -25° (Back) |
| **15** (Down) | -1 vox | +2° (R) | -30° (Toe) | +15° | +20° | -15° |
| **18** (Passing)| +0.5 vox| 0° | +20° (Bending)| 0° (Straight)| 0° | 0° |
| **21** (Up) | +1 vox | -2° (L) | +35° (Lifting)| -15° | -20° | +15° |
| **24** (Loop) | = Frame 0 | = Frame 0 | = Frame 0 | = Frame 0 | = Frame 0 | = Frame 0 |

## Attack Cycle (Sword Slash, 18 Frames = 0.3s)
- **Frames 0-3 (Windup)**: Arm pulls back to +70°, torso twists opposite direction.
- **Frames 4-6 (Strike)**: Rapid, powerful snap down to -60°. Anticipation releases into instant hit frame.
- **Frames 7-12 (Follow-through)**: Overshoot and blade deceleration.
- **Frames 13-18 (Recovery)**: Return smoothly to ready combat stance.
