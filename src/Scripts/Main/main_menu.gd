class_name MainMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Music
@onready var continue_button : Button = $Continue
@onready var ambience: AudioStreamPlayer = $Ambience

@export var next_scene_path : String
@onready var start_new_game_notice_panel: Panel = $StartNewGameNoticePanel

func _ready() -> void:
	if SaveManager.save_file_exists():
		continue_button.show()
	else:
		continue_button.hide()
	
	audio_stream_player.play()
	ambience.play()
	animation_player.play("FadeIn")
	
	
func go_to_next_scene() -> void:
	animation_player.play("FadeOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(next_scene_path) #go to tutorial map
	

func go_to_starspire() -> void:
	SaveManager.load_game()
	QuestManager.load_all_quest_status()
	#QuestManager.connect_active_main_quest_signals()
	animation_player.play("FadeOut")
	await get_tree().create_timer(1.0).timeout
	GameManager.resupply_character = true
	get_tree().change_scene_to_file("res://src/Scenes/NewStarshire/NewNewStarshireTest.tscn") 
	#get_tree().change_scene_to_file("uid://b0iw5pa4foen0")
	
func _on_button_button_up() -> void:

	if SaveManager.save_file_exists():
		start_new_game_notice_panel.show()
	else:
		SaveManager.create_new_save()
		go_to_next_scene()

func _on_continue_button_up() -> void:
	SaveManager.load_game()
	SaveManager.save_player_stats()
	go_to_starspire()


func _on_yes_button_button_up() -> void:
	SaveManager.create_new_save()
	go_to_next_scene()


func _on_no_button_button_up() -> void:
	start_new_game_notice_panel.hide()
