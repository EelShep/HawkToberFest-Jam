class_name MainMenuScreens extends ScreensManager

const MENU_SCREEN: int = 0

signal start_game()
signal reset_game()
signal quit_game()


func _ready() -> void:
	super()
	change_screen(screens[0])


func on_enter(screen_id: int = 0) -> void:
	if screens[screen_id] != null: change_screen(screens[screen_id])


#region Signal Functions
func _on_button_pressed(button: ScreenButton) -> void:
	match button.name:
		"MainMenuStart":
			change_screen(null)
			start_game.emit()
		"MainMenuReset":
			reset_game.emit()
		"MainMenuQuit":
			change_screen(null)
			quit_game.emit()



func _on_screen_exit(screen: Screen, exit_all: bool = false) -> void:
	if screen != screens[MENU_SCREEN]:
		change_screen(screens[MENU_SCREEN])

func _on_screen_manager_exited(screen: ScreensManager, exit_all: bool = false) -> void:
	change_screen(screens[MENU_SCREEN])
