extends RayCast3D
class_name UseRay

@export var distance : float = 1.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("use"): return
	if !is_colliding(): return
