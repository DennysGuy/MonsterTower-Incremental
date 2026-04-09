class_name ChallengeActivationSwitch extends Node2D

@onready var notice: Label = $Notice
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var switched_on : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and !switched_on:
		animation_player.play("SwitchOn")
		switched_on = true
		GameManager.boss_door_challenge_active = true
		notice.hide()
		SignalBus.start_boss_door_challenge_scene.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !GameManager.boss_door_challenge_active:
		notice.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		notice.hide()
