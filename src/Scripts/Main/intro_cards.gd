class_name IntroCards extends Control

@onready var title_text: RichTextLabel = $TitleText
@onready var graphic: TextureRect = $Graphic

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

var card_count : int = 0
const _2 = preload("uid://dl8w8ro8yi3vx")
const _3 = preload("uid://ctvg42h0aloth")
const _4 = preload("uid://bagekudwnshbn")
const _5 = preload("uid://bodp2snoia138")
const _6 = preload("uid://ciqgtvdptk4t1")
const _7 = preload("uid://5wqt78qs6x77")
const _1 = preload("uid://17uguyc6phmr")



@onready var pictures : Array[Texture2D]= [_1,_2,_3,_4,_5,_6,_7]
var current_frame : int = 0

const INTRODUCTION_THEME_TEMP = preload("uid://dbrvuid1nhetp")
 
const INTRO_CARDS_CUTSCENE = preload("uid://ia0sog54fgve")
var current_dialogue = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CutsceneManager.trigger_next_image.connect(trigger_next_frame)
	MusicPlayer.play_song(INTRODUCTION_THEME_TEMP)
	animation_player.play("FadeIn")
	current_dialogue = Dialogic.start(INTRO_CARDS_CUTSCENE)
	print(current_dialogue)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_tutorial() -> void:
	get_tree().change_scene_to_file("uid://dydvk8wswlc3l")

func next_image() -> void:
	await get_tree().process_frame
	
	current_frame += 1
	if current_frame <= pictures.size()-1:
		graphic.texture = pictures[current_frame]
	else:
		go_to_tutorial()

func trigger_next_frame() -> void:
	animation_player_2.play("CrossFade")


func _on_skip_button_button_up() -> void:
	Dialogic.end_timeline()
	MusicPlayer.play_tutorial_map_theme()
	animation_player_2.play("fade_out")
	
