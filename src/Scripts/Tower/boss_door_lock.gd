class_name BossKeyLock extends Node2D

var player : Player
var correct_key_detected : bool = false
var key_inserted : bool = false

@export var graphic : Sprite2D
@export var filled_graphic : Texture2D
@export var unfilled_graphic : Texture2D
@export var move_to_marker: Marker2D
@export var notice: Label
@export var stored_key : BossDoorKey

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_lock_unfilled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player and correct_key_detected:
		stored_key = player.held_key
		GameManager.can_issue_abilities = true
		player.held_key.go_to_key_lock(move_to_marker)
		player.held_key = null
		GameManager.event_speed_mod = 1.0

func set_lock_filled() -> void:
	graphic.texture = filled_graphic

func set_lock_unfilled() -> void:
	graphic.texture = unfilled_graphic
