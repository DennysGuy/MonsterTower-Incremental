class_name MainMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var continue_button : Button = $Continue

@export var next_scene_path : String

func _ready() -> void:
	if SaveManager.save_file_exists():
		continue_button.show()
	else:
		continue_button.hide()
	
	audio_stream_player.play()
	animation_player.play("FadeIn")
	
	
func go_to_next_scene() -> void:
	animation_player.play("FadeOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(next_scene_path) #go to tutorial map
	

func go_to_starspire() -> void:
	SaveManager.load_game()
	animation_player.play("FadeOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/NewStarshire/NewNewStarshireTest.tscn") 
	
func _on_button_button_up() -> void:
	SaveManager.create_new_save()
	go_to_next_scene()

func _on_continue_button_up() -> void:
	SaveManager.load_game()
	SaveManager.save_player_stats()
	go_to_starspire()
