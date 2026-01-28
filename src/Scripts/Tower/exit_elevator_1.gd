class_name ExitElevator extends Node2D

@export var next_room : PackedScene
var player_in_range : bool = false
var kill_quota_met : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_to_next_room_label: Label = $MoveToNextRoomLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.unlock_next_room.connect(unlock_next_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and kill_quota_met:
		SignalBus.move_to_next_room.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		
		if kill_quota_met:
			move_to_next_room_label.text = "Press 'E' to advance to next floor!"
			animation_player.play("DoorsOpen")
		else:
			move_to_next_room_label.text = "Meet the Floor's Kill Quota to advance."

		
		move_to_next_room_label.show()
		

func unlock_next_room() -> void:
	kill_quota_met = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range =false
		move_to_next_room_label.hide()
		animation_player.play("DoorsClose")
