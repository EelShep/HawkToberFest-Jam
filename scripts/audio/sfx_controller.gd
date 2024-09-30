class_name SFXController extends Node

@export var players: int
@export var sfx: Dictionary

@export var cut_off: bool = false

func _ready() -> void:
	for i in range(players):
		var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_player.bus = AudioConst.BUS_SFX_NM
		add_child(audio_player)


func play_sfx(sfx_idx: int, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var sfx_player: Variant
	if cut_off: sfx_player = get_child(0)
	else: sfx_player = get_available_player()
	if not sfx_player: return
	var sfx_stream: AudioStream = get_sfx_stream(sfx_idx)
	if not sfx_stream: return
	sfx_player.stream = sfx_stream
	sfx_player.volume_db = volume_db
	sfx_player.pitch_scale = pitch_scale
	sfx_player.play()


func get_available_player(is_positional: bool = false) -> Variant:
	for player in get_children():
		if is_positional && player is not AudioStreamPlayer3D: continue
		if not player.playing: return player
	push_warning("No available sfx player found.")
	return null


func get_sfx_stream(sfx_idx: int) -> Variant:
	if sfx_idx in sfx:
		var sfx_stream: AudioStream = sfx[sfx_idx]
		return sfx_stream
	return null
