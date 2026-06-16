class_name PrevElevator extends Node2D

@export var current_floor_data : TowerEntranceData
@export var prev_floor_data : TowerEntranceData
@export var last_spawn_point : int
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_to_next_room_label: Label = $MoveToNextRoomLabel
@onready var tag: Label = $NameTag/Bg/Tag

var player_in_range : bool = false
var doors_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tag.text = prev_floor_data.floor_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and doors_open:
		go_to_prev_floor()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if !GameManager.hunt_challenge_selected:
			if ExpeditionTimer.seconds <= 10:
				move_to_next_room_label.modulate = Color.INDIAN_RED
				move_to_next_room_label.text = "Insufficient Time Remaining"
			else:
				doors_open = true
				move_to_next_room_label.modulate = Color.WHITE
				animation_player.play("DoorsOpen")
				move_to_next_room_label.text = "Press %s to Move to Previous Floor" % GameManager.get_control_mapping("interact")
		
		move_to_next_room_label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		if doors_open:
			animation_player.play("DoorsClose")
			doors_open = false
		move_to_next_room_label.hide()
		
func go_to_prev_floor() -> void:
	if current_floor_data.is_boss_door():
		MusicPlayer.transitioning_floors = false
	else:
		MusicPlayer.transitioning_floors = true 
	GameManager.spawn_location = last_spawn_point
	SignalBus.move_to_next_room.emit(prev_floor_data.scene_path)
