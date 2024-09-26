extends Camera3D
class_name TrackingCamera

@export var target : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !target: 
		set_process(false)
		return
	track()

func activate(new_target: Node3D) -> void:
	target = new_target
	set_process(true)

func track() -> void:
	look_at(target.global_position)
