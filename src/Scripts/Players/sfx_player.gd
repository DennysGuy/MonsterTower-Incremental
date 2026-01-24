class_name SFXPlayer extends AudioStreamPlayer

func play_sfx(audio_stream : AudioStream, volume : float = 0.0, randomized_pitch : bool = false, pitch : float = 1.0) -> void:
	stream = audio_stream
	volume_db = volume
	pitch_scale = pitch
	if randomized_pitch:
		pitch_scale = randomize_pitch()
	play()

func randomize_pitch() -> float:
	return randf_range(0.5,0.7)
