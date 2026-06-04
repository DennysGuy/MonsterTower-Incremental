class_name IntroCards extends Control

@onready var title_text: RichTextLabel = $TitleText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

var card_count : int = 0

@onready var card_animations : Array[String]= ["text1","text2","text3","text4","text5","text6","text7","text8"]


const INTRODUCTION_THEME_TEMP = preload("uid://dbrvuid1nhetp")
 
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_song(INTRODUCTION_THEME_TEMP)
	await get_tree().create_timer(1.0).timeout
	play_animation(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_tutorial() -> void:
	get_tree().change_scene_to_file("uid://dydvk8wswlc3l")

func play_animation(index : int) -> void:

	animation_player.play(card_animations[index])

func _on_button_button_up() -> void:
	if card_count < card_animations.size()-1:
		card_count += 1
		play_animation(card_count)
	else:
		MusicPlayer.stop_player()
		animation_player_2.play("fade_out")
