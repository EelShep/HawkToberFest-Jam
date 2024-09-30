class_name ScreensManager
extends Control

signal exit_screens() #For returning from submenus

@export var screens: Array[Screen]
@export var screen_managers: Array[ScreensManager]
@export var button_groups: Array[String] = ["screen_buttons"]
var current_screen: Control = null

#region ScreenManager Setup
func _ready() -> void:
	register_buttons()
	register_screens()
	register_screen_managers()
	change_screen(null)


func register_buttons() -> void:
	for group in button_groups:
		get_tree().call_group(group, "set_disabled", true)
		var screen_buttons: Array[Node] = get_tree().get_nodes_in_group(group)
		if screen_buttons.size() > 0:
			for button in screen_buttons:
				if button is ScreenButton: (button as ScreenButton).clicked.connect(_on_button_pressed)


func register_screens() -> void:
	for screen in screens:
		(screen as Screen).hide() #TODO Test side effects
		(screen as Screen).exit_screen.connect(_on_screen_exit)


func register_screen_managers() -> void:
	for screen_manager in screen_managers:
		(screen_manager as ScreensManager).show() #TODO Test side effects
		(screen_manager as ScreensManager).exit_screens.connect(_on_screen_manager_exited)
#endregion

#TODO Tidy/Fix
func change_screen(new_screen: Screen) -> bool:
	if current_screen != null:
		#Disable Process & Buttons
		current_screen.set_process_input(false)
		for group in button_groups: get_tree().call_group(group, "set_disabled", true) #TODO Remove?
		#Tween Animation
		var disappear_tween: Tween = current_screen.disappear()
		await disappear_tween.finished
		if current_screen: current_screen.hide() #TODO Fix
	current_screen = new_screen
	if current_screen != null:
		#Tween Animation
		var appear_tween: Tween = current_screen.appear()
		await appear_tween.finished
		#Enable Process & Buttons. Then Grab Focus Button
		for group in button_groups: get_tree().call_group(group, "set_disabled", false)
		if current_screen: #TODO Fix
			current_screen.set_process_input(true)
			current_screen.grab_focus_button()
	return true

#Default ScreenManager enter function, specialized version when needed is called enter()
func on_enter(screen_id: int = 0) -> void:
	if screens[screen_id] != null: change_screen(screens[screen_id])


#region Signal Functions
func _on_button_pressed(button: ScreenButton) -> void:
	pass


func _on_screen_exit(screen: Screen, exit_all: bool = false) -> void:
	if exit_all or screen.always_exit:
		change_screen(null)
		exit_screens.emit(self, exit_all)
	else: change_screen(screens[0])


func _on_screen_manager_exited(screen: ScreensManager, exit_all: bool = false) -> void:
	if exit_all:
		change_screen(null)
		exit_screens.emit(self, exit_all)
	else: change_screen(screens[0])
#endregion
