class_name ExitElevator extends Node2D

@export var next_room : PackedScene
var player_in_range : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_to_next_room_label: Label = $MoveToNextRoomLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		SignalBus.move_to_next_room.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		move_to_next_room_label.show()
		animation_player.play("DoorsOpen")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range =false
		move_to_next_room_label.hide()
		animation_player.play("DoorsClose")
