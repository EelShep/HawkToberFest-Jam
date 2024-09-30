extends CharacterBody3D
class_name Player

@export var ROT_OFFSET     : float = 0.0

@export var SPEED          : float = 1.75
@export var TURN_SPEED     : float = 2.0
@export var JUMP_VELOCITY  : float = 4.5

@export var model          : Node
@export var animator       : AnimationPlayer
@export var room_activator : RoomActivator

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var turn_dir : float = Input.get_action_strength("left") - Input.get_action_strength("right")
	model.rotation.y += turn_dir * TURN_SPEED * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Vector2(0,Input.get_action_strength("backward") - Input.get_action_strength("forward"))#Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP,model.rotation.y + ROT_OFFSET)).normalized()
	if direction:
		if !animator.is_playing() or animator.current_animation != "walking":
			animator.play("walking")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !animator.is_playing() or animator.current_animation != "idle_01":
			animator.play("idle_01")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
