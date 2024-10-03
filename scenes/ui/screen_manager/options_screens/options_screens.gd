class_name OptionsScreens extends ScreensManager

const OPTIONS_SCREEN: int = 0
const CONTROLS_SCREEN: int = 1

func _ready() -> void:
	super()


func on_enter(screen_id: int = 0) -> void:
	if screens[screen_id] != null: change_screen(screens[screen_id])


#region Signal Functions
func _on_button_pressed(button: ScreenButton) -> void:
	match button.name:
		"OptionsControls":
			change_screen(screens[CONTROLS_SCREEN])
		"OptionsBack":
			change_screen(null)
			exit_screens.emit(self)
		"ControlsBack":
			change_screen(screens[0])


func _on_screen_exit(screen: Screen, exit_all: bool = false) -> void:
	if screen == screens[OPTIONS_SCREEN] || exit_all or screen.always_exit:
		change_screen(null)
		exit_screens.emit(self, exit_all)
	else: change_screen(screens[OPTIONS_SCREEN])


func _on_screen_manager_exited(screen: ScreensManager, exit_all: bool = false) -> void:
	if exit_all:
		change_screen(null)
		exit_screens.emit(self, exit_all)
	else: change_screen(screens[OPTIONS_SCREEN])
