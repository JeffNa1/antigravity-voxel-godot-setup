extends CharacterBody3D
class_name VoxelCharacterController

## Movement Configuration
@export var walk_speed: float = 4.0
@export var run_speed: float = 7.5
@export var jump_velocity: float = 6.0
@export var rotation_speed: float = 12.0
@export var gravity: float = 18.0

@onready var visual_pivot: Node3D = $VisualPivot
@onready var anim_player: AnimationPlayer = $VisualPivot/AnimationPlayer

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
    # 1. Apply gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # 2. Handle Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity
        play_anim("jump")

    # 3. Read Movement Input
    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    var is_running := Input.is_action_pressed("sprint")
    var target_speed := run_speed if is_running else walk_speed

    if direction:
        velocity.x = direction.x * target_speed
        velocity.z = direction.z * target_speed

        # Rotate visual mesh towards moving direction
        var target_rotation := atan2(-direction.x, -direction.z)
        visual_pivot.rotation.y = lerp_angle(visual_pivot.rotation.y, target_rotation, rotation_speed * delta)

        if is_on_floor():
            play_anim("run" if is_running else "walk")
    else:
        velocity.x = move_toward(velocity.x, 0, target_speed)
        velocity.z = move_toward(velocity.z, 0, target_speed)
        if is_on_floor():
            play_anim("idle")

    move_and_slide()

func play_anim(anim_name: String) -> void:
    if anim_player and anim_player.has_animation(anim_name):
        if anim_player.current_animation != anim_name:
            anim_player.play(anim_name)
