class_name ScreenButton
extends Button #TODO Make TextureButton?

signal clicked(button: ScreenButton)

@export var group: String = "screen_buttons"
@export var button_type: ButtonType = ButtonType.NONE

enum ButtonType{
	Click = AudioConst.UI_SFX_CLICK,
	NegativeClick = AudioConst.UI_SFX_NEGATIVE,
	Negative2 = AudioConst.UI_SFX_CLOSE,
	NONE = 99
}

var is_clicked: bool = false


func _ready() -> void:
	add_to_group(group)
	pressed.connect(_on_pressed)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)


func _on_focus_entered() -> void:
	if not is_clicked: 
		AudioController.play_ui_sfx(AudioConst.UI_SFX_HOVER, 7)
		is_clicked = false
	else: is_clicked = false


func _on_focus_exited() -> void:
	pass

	
func _on_pressed() -> void:
	clicked.emit(self)
	AudioController.play_ui_sfx(button_type)
