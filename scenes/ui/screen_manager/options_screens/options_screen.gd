extends Screen


func appear() -> Tween:
	show()
	on_appear()
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 1.0, fade_dur)
	return tween


func on_appear() -> void:
	%FullscreenCheckbox.grab_focus()
	init_video()
	init_audio()
	

func init_video() -> void:
	var screen_type: Variant = SaveData.config.get_value("video", "fullscreen")
	%FullscreenCheckbox.button_pressed = true if screen_type == DisplayServer.WINDOW_MODE_FULLSCREEN else false
	%FullscreenCheckbox.toggled.connect(_on_fullscreen_toggled)
	%FullscreenCheckbox.focus_entered.connect(_on_focus_entered)
func init_audio() -> void:
	#NOTE Get Save values
	%MasterHSlider.value = SaveData.config.get_value("audio", "0")
	%SFXHSlider.value = SaveData.config.get_value("audio", "1")
	%MusicHSlider.value = SaveData.config.get_value("audio", "2")
	#NOTE Connect signals
	%MasterHSlider.value_changed.connect(_on_master_changed)
	%MusicHSlider.value_changed.connect(_on_music_changed)
	%SFXHSlider.value_changed.connect(_on_sfx_changed)
	%MasterHSlider.focus_entered.connect(_on_focus_entered)
	%MusicHSlider.focus_entered.connect(_on_focus_entered)
	%SFXHSlider.focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	AudioController.play_ui_sfx(AudioConst.UI_SFX_HOVER)
	

func _on_master_changed(value: float) -> void:
	set_volume(AudioConst.BUS_MASTER_IDX, value)


func _on_sfx_changed(value: float) -> void:
	set_volume(AudioConst.BUS_SFX_IDX, value)


func _on_music_changed(value: float) -> void:
	set_volume(AudioConst.BUS_MUSIC_IDX, value)


func set_volume(idx: int, value: float) -> void:
	if value == 0.0: AudioServer.set_bus_volume_db(idx, -80.0)
	else: AudioServer.set_bus_volume_db(idx, AudioController.lerp_to_db(value))
	SaveData.config.set_value("audio", str(idx), value)
	print(AudioServer.get_bus_volume_db(idx))
	print(value)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
		SaveData.config.set_value("video", "fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SaveData.config.set_value("video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
	#TODO Fix SFX plays on Config load
	AudioController.play_ui_sfx(AudioConst.UI_SFX_CLICK)


func disappear() -> Tween:
	set_process_input(false)
	on_disappear()
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 0.0, fade_dur)
	return tween

func on_disappear() -> void:
	#NOTE Save values
	SaveData.save_config()
	#NOTE Disconnect signals
	%FullscreenCheckbox.toggled.disconnect(_on_fullscreen_toggled)
	%FullscreenCheckbox.focus_entered.disconnect(_on_focus_entered)
	%MasterHSlider.value_changed.disconnect(_on_master_changed)
	%MusicHSlider.value_changed.disconnect(_on_music_changed)
	%SFXHSlider.value_changed.disconnect(_on_sfx_changed)
	%MasterHSlider.focus_entered.disconnect(_on_focus_entered)
	%MusicHSlider.focus_entered.disconnect(_on_focus_entered)
	%SFXHSlider.focus_entered.disconnect(_on_focus_entered)


func grab_focus_button() -> void:
	if not focus_button: return
	focus_button.is_clicked = true
	focus_button.grab_focus()
