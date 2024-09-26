extends RayCast3D
class_name RoomActivator



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_from_inside     = true
	collision_mask      = -2147483648
	collide_with_areas  = true
	collide_with_bodies = false
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_colliding(): return
	var collider = get_collider()
	if !collider is RoomArea: return
	collider.activate(self)
	set_physics_process(false)

func activate() -> void:
	set_physics_process(true)
