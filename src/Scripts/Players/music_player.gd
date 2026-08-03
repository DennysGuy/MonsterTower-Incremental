extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var transitioning_floors : bool = false
const INTRO_STAGE_THEME_TEST = preload("uid://0nrbfbgv25o0")
const BOOTCAMP_THEME = preload("uid://cyslu12povi21")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_song(song : AudioStream, db : float = 0.0) -> void:
	audio_stream_player.volume_db = db
	audio_stream_player.stream = song
	audio_stream_player.play()

func stop_player(fade_out : bool = false) -> void:
	if fade_out:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -30.0, 1.0)
	audio_stream_player.volume_db = 0.0
	audio_stream_player.stop()

func pause_music() -> void:
	audio_stream_player.stream_paused = true

func unpause_music() -> void:
	audio_stream_player.stream_paused = false

func play_tutorial_map_theme() -> void:
	audio_stream_player.stream = INTRO_STAGE_THEME_TEST
	audio_stream_player.play()

func play_bootcamp_theme() -> void:
	audio_stream_player.stream = BOOTCAMP_THEME
	audio_stream_player.play()
