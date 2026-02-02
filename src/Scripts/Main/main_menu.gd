class_name MainMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var next_scene_path : String

func _ready() -> void:
	audio_stream_player.play()
	animation_player.play("FadeIn")


func go_to_next_scene() -> void:
	animation_player.play("FadeOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(next_scene_path) #go to tutorial map
	

func _on_button_button_up() -> void:
	go_to_next_scene()
