extends Node

const SAVE_PATH: String = "user://save_data.sav"
const CONFIG_PATH: String = "user://settings.cfg"
var config: ConfigFile = ConfigFile.new()

var new_save: bool = true

func _ready() -> void:
	# Game Data
	if FileAccess.file_exists(SAVE_PATH):
		load_game()
	else: reset_game()
	# Config Data
	reset_config()
	load_config()

#region Game Data Functions
func load_game() -> void:
	var file: Variant = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var loaded_data: Variant = str_to_var(file.get_as_text())
	if loaded_data is not Dictionary:
		push_error("Game failed to load")
		return
	new_save = (loaded_data as Dictionary).get("new_save")
	#TODO Load GameData


func save_game() -> void:
	var save_data: Dictionary = {}
	save_data["new_save"] = new_save
	#TODO Get game data
	FileAccess.open(SAVE_PATH, FileAccess.WRITE)\
		.store_string(var_to_str(save_data))

func _exit_tree() -> void:
	save_game()

func reset_game() -> void:
	new_save = true
	#TODO Reset GameData
	save_game()
#endregion
#region Config
func load_config() -> void:
	if config.load(CONFIG_PATH) == OK:
		load_video_config()
		load_audio_config()
	else: save_config()


func save_config() -> void:
	config.save(CONFIG_PATH)

	
func reset_config() -> void:
	var window_mode: Variant = DisplayServer.WINDOW_MODE_FULLSCREEN
	if OS.get_name() == "Web": window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	config.set_value("video", "fullscreen", window_mode)
	for i in range(AudioConst.AUDIO_BUSES):
		config.set_value("audio", str(i), 0.5)
		
	
func load_video_config() -> void:
	var screen_type: Variant = config.get_value("video", "fullscreen")
	DisplayServer.window_set_mode(screen_type)


func load_audio_config() -> void:
	for i in range(3):
		var value: float = config.get_value("audio", str(i))
		AudioServer.set_bus_volume_db(i, AudioController.lerp_to_db(value))
#endregion
