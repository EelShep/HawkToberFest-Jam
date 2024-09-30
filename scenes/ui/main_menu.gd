extends CanvasLayer

@export var main_menu_screens: MainMenuScreens
#@export var quit_button: ScreenButton

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	Events.main_menu_ready.emit()
	
	#TODO 
	#if OS.get_name() == "Web":
		#quit_button.hide()
	
	main_menu_screens.start_game.connect(_on_play_pressed)
	main_menu_screens.reset_game.connect(_on_reset_pressed)
	main_menu_screens.quit_game.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/test.tscn")
	Events.game_ready.emit() #ALERT REMOVE


func _on_reset_pressed() -> void: pass
	#TODO SaveData.reset_game()


func _on_quit_pressed() -> void:
	get_tree().create_timer(0.5).timeout.connect(func() -> void: get_tree().quit())
	
