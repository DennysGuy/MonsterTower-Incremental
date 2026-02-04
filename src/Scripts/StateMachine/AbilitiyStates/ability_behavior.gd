class_name AbilityBehavior extends Resource

var parent : Player

@export var animation_name : String
@export var animation_duration : float
@export var sfx : AudioStream

func on_enter(player : Player) -> void:
	pass
	
func apply_physics() -> State:
	return null
