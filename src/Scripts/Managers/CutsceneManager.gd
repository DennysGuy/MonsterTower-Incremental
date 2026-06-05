extends Node


@warning_ignore("unused_signal")
signal trigger_next_image

func trigger_next_frame() -> void:
	trigger_next_image.emit()
