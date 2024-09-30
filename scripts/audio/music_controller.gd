class_name MusicController extends Node

const FADEOUT_DB: float = -50.0
const FADEIN_DB: float = 0.0

@export var fade_out_dur: float = 0.75
@export var fade_in_dur: float = 0.375

@export var music: Dictionary

var music_player: AudioStreamPlayer

var track_id: int = -99

var tween: Tween

func _ready() -> void:
	var _music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	_music_player.bus = AudioConst.BUS_MUSIC_NM
	music_player = _music_player
	add_child(music_player)


func play_music(music_idx: int) -> void:
	if not music_idx in music: return
	if track_id == music_idx: return
	track_id = music_idx
	await fade_music_player().finished
	music_player.stream = music[music_idx]
	music_player.play()
	fade_music_player(false).finished


func fade_music_player(fade_out: bool = true) -> Tween:
	if tween and tween.is_running(): 
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if fade_out:
		tween.tween_property(music_player, "volume_db", FADEOUT_DB, fade_out_dur).from(FADEIN_DB)
	else:tween.tween_property(music_player, "volume_db", FADEIN_DB, fade_in_dur).from(FADEOUT_DB)
	return tween


func play_music_stream(music_stream: AudioStream) -> void:
	music_player.stream = music_stream
	music_player.play()
