class_name GreySentinelMini extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const EXPLOSION_DEATH = preload("uid://cqefvj6l8lucj")
const ACTIVATE = preload("uid://kqy8hcm210eh")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_deactivated_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_activation_animation() -> void:
	play_sfx(ACTIVATE)
	animation_player.play("Activate")

func play_idle_animation() -> void:
	animation_player.play("Idle")

func play_deactivated_animation() -> void:
	animation_player.play("Deactivated")

func play_death_animation() -> void:
	play_sfx(EXPLOSION_DEATH)
	animation_player.play("Death")


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
