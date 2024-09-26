extends Area3D
class_name RoomArea


@export var camera : Camera3D

func _ready() -> void:
	collision_layer = -2147483648
	collision_mask  = 1

func activate(target: Node3D) -> void: 
	if !camera: return
	camera.set_current(true)
	if !(camera is TrackingCamera): return
	camera.activate(target)


func _on_body_entered(body: Node3D) -> void:
	if !(body is Player): return
	if !body.room_activator: return
	body.room_activator.activate()
