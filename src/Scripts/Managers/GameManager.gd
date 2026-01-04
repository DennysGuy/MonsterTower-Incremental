extends Node


var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_location : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_location = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
