class_name MainMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Music
@onready var continue_button : Button = $Continue
@onready var ambience: AudioStreamPlayer = $Ambience

@export var next_scene_path : String
@onready var start_new_game_notice_panel: Panel = $StartNewGameNoticePanel
@onready var new_game: Button = $NewGame
@onready var settings_button: Button = $SettingsButton

const MAIN_MENU_BUTTON_HOVER = preload("uid://boacm1t1oc0dc")
const MAIN_MENU_BUTTON_PRESS = preload("uid://vy5spvqctg68")

func _ready() -> void:
	if SaveManager.save_file_exists():
		continue_button.show()
	else:
		continue_button.hide()
	
	await get_tree().process_frame
	
	audio_stream_player.play()
	ambience.play()
	animation_player.play("FadeIn")
	await get_tree().create_timer(3.0).timeout
	animation_player.play("FadeInMenu")
	
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
	GameManager.play_sfx(MAIN_MENU_BUTTON_PRESS)
	if SaveManager.save_file_exists():
		start_new_game_notice_panel.show()
	else:
		SaveManager.create_new_save()
		go_to_next_scene()

func _on_continue_button_up() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_PRESS)
	SaveManager.load_game()
	SaveManager.save_player_stats()
	go_to_starspire()

func _on_yes_button_button_up() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_PRESS)
	SaveManager.create_new_save()
	go_to_next_scene()

func _on_no_button_button_up() -> void:
	start_new_game_notice_panel.hide()

func _on_exit_button_button_up() -> void:
	get_tree().quit()

func _on_settings_button_button_up() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_PRESS)
	add_settings_menu()

func add_settings_menu() -> void:
	var settings_menu : PauseMenu = preload("uid://dlaq2oh2iuyjk").instantiate()
	settings_menu.pause_game = false
	add_child(settings_menu)

func _on_new_game_mouse_entered() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_HOVER)
	big_mode(new_game)


func _on_new_game_mouse_exited() -> void:
	small_mode(new_game)


func big_mode(button : Button) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.12,1.12), 0.1)
	
func small_mode(button : Button) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.0,1.0), 0.1)


func _on_settings_button_mouse_entered() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_HOVER)
	big_mode(settings_button)


func _on_settings_button_mouse_exited() -> void:
	small_mode(settings_button)


func _on_continue_mouse_entered() -> void:
	GameManager.play_sfx(MAIN_MENU_BUTTON_HOVER)
	big_mode(continue_button)

func _on_continue_mouse_exited() -> void:
	small_mode(continue_button)

func _on_steam_button_button_up() -> void:
	OS.shell_open("https://store.steampowered.com/app/4937380/Starspire_Hunters/")


func _on_discord_button_button_up() -> void:
	OS.shell_open("https://discord.gg/gfFRPaCGFb")
