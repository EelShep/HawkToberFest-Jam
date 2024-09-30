extends AnimatableBody3D
class_name Door

enum {
	OPEN,
	MOVING,
	CLOSED
}

@export_enum("OPEN", "MOVING", "CLOSED")  var state : int   = CLOSED
@export var auto_close                              : bool  = false
@export var auto_close_timeout                      : float = 3.0 
@export var locked                                  : bool  = false

@export var open_sounds  : Array[AudioStream]
@export var close_sounds : Array[AudioStream]

func _ready() -> void:
	$left_side.collision_layer = 0
	$left_side.collision_mask  = 2
	
	$right_side.collision_layer = 0
	$right_side.collision_mask  = 2

func use() -> void:
	if state == MOVING: return
	var left_bodies  = $left_side.get_overlapping_bodies()
	var right_bodies = $right_side.get_overlapping_bodies()
	if !left_bodies and !right_bodies: return
	if state == CLOSED:
		$AudioStreamPlayer3D.stream = open_sounds.pick_random()
		$AudioStreamPlayer3D.play()
		if   left_bodies:  $AnimationPlayer.play("open_l")
		elif right_bodies: $AnimationPlayer.play("open_r")
	if state == OPEN:
		$AudioStreamPlayer3D.stream = close_sounds.pick_random()
		$AudioStreamPlayer3D.play()
		if   left_bodies:  $AnimationPlayer.play("close_l")
		elif right_bodies: $AnimationPlayer.play("close_r")

func start_auto_close_timeout():
	if !auto_close: return
	await get_tree().create_timer(auto_close_timeout).timeout
	$AnimationPlayer.play_backwards($AnimationPlayer.current_animation)
	
