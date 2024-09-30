class_name Screen
extends Control

signal exit_screen(self_ref: Screen, exit_all: bool)

@export var fade_dur: float = 0.2 #TODO TEST Move to ScreenManager
@export var focus_button: ScreenButton
@export var always_exit: bool = false


func _input(event: InputEvent) -> void:
	#TODO if GameData.is_gamepad: GameData.get_gamepad_type(event.device)
	if event.is_action_pressed("ui_cancel"):
		set_process_input(false)
		exit_screen.emit(self)
		AudioController.play_ui_sfx(AudioConst.UI_SFX_NEGATIVE)
	elif event.is_action_pressed(GameConst.INPUT_START):
		set_process_input(false)
		exit_screen.emit(self, true)
		AudioController.play_ui_sfx(3)
	

func _ready() -> void:
	set_process_input(false)
	hide()
	modulate.a = 0.0


func appear() -> Tween:
	show()
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 1.0, fade_dur)
	return tween


func disappear() -> Tween:
	set_process_input(false)
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 0.0, fade_dur)
	return tween


func grab_focus_button() -> void:
	if not focus_button: return
	focus_button.is_clicked = true
	focus_button.grab_focus()
