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

const MOUNT_ABILITY = preload("uid://bi0i27cx48wbe")
const RETRO_WEIRD_07 = preload("uid://d1yeatmrclw4w")

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


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
