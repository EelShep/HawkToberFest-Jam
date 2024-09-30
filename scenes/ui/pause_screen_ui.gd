class_name PauseScreenUI extends CanvasLayer

@export var background: ColorRect
@export var pause_screens: ScreensManager

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(GameConst.INPUT_START):
		if get_tree().paused != true: show_pause_screen()

func _ready() -> void:
	get_tree().paused = false
	set_process_unhandled_input(true)
	pause_screens.exit_screens.connect(_on_screens_exited.unbind(2))
	background.modulate.a = 0.0
	background.hide()


func show_pause_screen() -> void:
	on_enter_menu()
	#TODO AudioController.play_ui_sfx(AudioConst.UI_SFX_OPEN)
	var tween: Tween = appear()
	await tween.finished
	pause_screens.on_enter()


func on_enter_menu() -> void:
	set_process_unhandled_input(false)
	Events.pause_toggled.emit(true)
	get_tree().paused = true
	var low_pass_idx: int = 0
	AudioServer.set_bus_effect_enabled(AudioConst.BUS_MUSIC_IDX, low_pass_idx, true)

func on_exit_menu() -> void:
	set_process_unhandled_input(true)
	Events.pause_toggled.emit(false)
	get_tree().paused = false
	var low_pass_idx: int = 0
	AudioServer.set_bus_effect_enabled(AudioConst.BUS_MUSIC_IDX, low_pass_idx, false)
	


func _on_screens_exited() -> void: #Resume Game
	var tween: Tween = disappear()
	await tween.finished
	on_exit_menu()


func appear() -> Tween:
	background.show()
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(background, "modulate:a", 1.0, 0.5).from(0.0)
	return tween


func disappear() -> Tween:
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(background, "modulate:a", 0.0, 0.5)
	return tween
