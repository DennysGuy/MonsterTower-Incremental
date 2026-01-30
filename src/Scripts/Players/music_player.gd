extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var transitioning_floors : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_song(song : AudioStream) -> void:
	audio_stream_player.volume_db = 0.0
	audio_stream_player.stream = song
	audio_stream_player.play()
	print(audio_stream_player.volume_db)

func stop_player(fade_out : bool = false) -> void:
	if fade_out:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -30.0, 1.0)
	audio_stream_player.volume_db = 0.0
	audio_stream_player.stop()
