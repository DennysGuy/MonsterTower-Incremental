class_name ChallengeActivationSwitch extends Node2D

@onready var notice: Label = $Notice
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var switched_on : bool = false
var player_in_range : bool = false
const LEVER_PULL = preload("uid://httoi7q6dybg")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and !switched_on:
		play_sfx(LEVER_PULL)
		animation_player.play("SwitchOn")
		switched_on = true
		GameManager.boss_door_challenge_active = true
		notice.hide()
		SignalBus.start_boss_door_challenge_scene.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !GameManager.boss_door_challenge_active:
		player_in_range = true
		notice.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
