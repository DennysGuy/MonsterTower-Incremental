class_name State
extends Node

@export
var animation_name: String
@export
var move_speed : int = 200

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent

func enter() -> void:
	if parent.animation_player:
		parent.animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
		
func set_animation_name(animation_name : String):
	self.animation_name = animation_name
