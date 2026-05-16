class_name BossDoor1 extends Node2D

@export var floor_data : TowerEntranceData
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var open_door_notice: Label = $OpenDoorNotice

var player_in_range : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		SignalBus.play_close_out_animation.emit()
		await get_tree().create_timer(0.5).timeout
		GameManager.player_can_move = true
		GameManager.resupply_character = true
		GameManager.spawn_location = 0

		PlayerStats.check_points_unlocked["Floor 1-7"] = true
		SaveManager.save_game()
		
		get_tree().change_scene_to_file("uid://b0iw5pa4foen0")

func play_door_open_animation() -> void:
	floor_data.hunt_challenge_completed = true
	floor_data.number_of_spawn_locations += 1
	SaveManager.save_floor_data(floor_data, "Floor 1-6")
	animation_player.play("open")
	await get_tree().create_timer(3.0).timeout
	player_in_range = true
	open_door_notice.show()

func play_door_close_animation() -> void:
	animation_player.play("close")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and floor_data.hunt_challenge_completed:
		player_in_range = true
		open_door_notice.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		open_door_notice.hide()
