class_name StateMachine extends Node

@export
var initial_state: State

var current_state: State
var previous_state: State
var previous_movespeed : float
func init(parent) -> void:
	for child in get_children():
		child.parent = parent
		
	change_state(initial_state)

func change_state(new_state: State) -> void:
	
	if current_state:
		current_state.exit()
	
	if not GameManager.player_can_move:
		return
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
		
	if get_parent() is CharacterBody2D:
		if get_parent().is_on_floor() or get_parent() is Player and current_state is PlayerClimb:
			get_parent().velocity.y = 0
		else:
			get_parent().velocity.y += GameManager.gravity * delta
	
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func return_to_previous_state() -> void:
	if previous_state:
		change_state(previous_state)
