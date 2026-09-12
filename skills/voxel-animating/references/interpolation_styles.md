# Interpolation Styles: Stepped vs Smooth in Godot 4 & Blender

## Configuring Stepped Animation in Blender
1. Select all keyframes in the Dope Sheet or Graph Editor (`A`).
2. Press `T` (Interpolation Mode) -> Select **Constant**.
3. For stepped keyframing at specific frame rates (e.g. 12 fps), use the **Stepped (F-Curve Modifier)**.

## Configuring Track Interpolation in Godot 4
In Godot 4, you can control track interpolation directly on the `Animation` resource:
- `Animation.INTERPOLATION_NEAREST`: Keyframes jump instantly (stepped / stop motion).
- `Animation.INTERPOLATION_LINEAR`: Linear interpolation between points.
- `Animation.INTERPOLATION_CUBIC`: Smooth Bezier-like curve.

### GDScript to set all tracks of an animation to Nearest (Stepped):
```gdscript
func make_animation_stepped(anim: Animation) -> void:
    for track_idx in range(anim.get_track_count()):
        anim.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
```
