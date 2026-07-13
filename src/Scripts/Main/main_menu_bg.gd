class_name MainMenuBG extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
const CLOSE_OUT = preload("uid://caj0oih8j2sty")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_2.play("SwoopIn")
	animation_player.play("boatbob")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_swoop_out() -> void:
	GameManager.play_sfx(CLOSE_OUT)
