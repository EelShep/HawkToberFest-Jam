extends Node


@onready var sfx_controller: SFXController = $SFXController
@onready var music_controller: MusicController = $MusicController

@onready var ui_sfx_controller: SFXController = $UISFXController


func _unhandled_input(event: InputEvent) -> void:
	if not OS.has_feature("editor"): return
	if event.is_action_pressed(GameConst.INPUT_SELECT):
		var music_bus: int = AudioConst.BUS_MUSIC_IDX
		AudioServer.set_bus_mute(music_bus, !AudioServer.is_bus_mute(music_bus))
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_K:
				AudioController.play_sfx(1)
		

func _ready() -> void:
	Events.main_menu_ready.connect(handle_main_menu_ready)
	Events.game_ready.connect(handle_game_ready)
	
	AudioServer.set_bus_volume_db(AudioConst.BUS_MASTER_IDX, -15.0)

	
func play_sfx(sfx_idx: int, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	sfx_controller.play_sfx(sfx_idx, volume_db, pitch_scale)


func play_music(music_idx: int) -> void:
	music_controller.play_music(music_idx)


func play_ui_sfx(sfx_idx: int, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	ui_sfx_controller.play_sfx(sfx_idx, volume_db, pitch_scale)


func toggle_bus_effect(bus_idx: int, effect_idx: int, value: bool) -> void:
	AudioServer.set_bus_effect_enabled(bus_idx, effect_idx, value)


func handle_main_menu_ready() -> void:
	#TODO music_controller.play_music(AudioConst.MUSIC_TITLE)
	reset_music_effects()

func handle_game_ready() -> void:
	#TODO music_controller.play_music(AudioConst.MUSIC_TITLE)
	reset_music_effects()

func reset_music_effects() -> void:
	music_controller.music_player.pitch_scale = 1.0
	toggle_bus_effect(AudioConst.BUS_MUSIC_IDX, AudioConst.BUS_FX_LOWPASS, false)
	

func lerp_to_db(value: float) -> float:
	return clampf(lerp(-25.0, 25.0, value), -15.0, 5.0)
