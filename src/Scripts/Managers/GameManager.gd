extends Node


var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_location : int
var player_can_move : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_can_move = true
	spawn_location = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_player_box_direction(flip_h : bool):
	if (flip_h):
		return -1
	else:
		return 1
