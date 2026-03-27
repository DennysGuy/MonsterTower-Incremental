class_name PrevElevator extends Node2D

@export var prev_floor_data : TowerEntranceData
@export var last_spawn_point : int
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_to_next_room_label: Label = $MoveToNextRoomLabel

var player_in_range : bool = false
var doors_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and doors_open:
		go_to_prev_floor()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if !GameManager.hunt_challenge_selected:
			doors_open = true
			animation_player.play("DoorsOpen")
			move_to_next_room_label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		if doors_open:
			animation_player.play("DoorsClose")
			move_to_next_room_label.hide()

func go_to_prev_floor() -> void:
	MusicPlayer.transitioning_floors = true
	GameManager.spawn_location = last_spawn_point
	SignalBus.move_to_next_room.emit(prev_floor_data.scene_path)
