class_name PlayerIdle extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State
@export var attack_1_state : State
@export var swing_pick_axe_state : State
@export var climb_state : State

@export_group("Audio")
@export var jump_sfx : AudioStream

func enter() -> void:
	parent.set_sword_texture(animation_name)
	parent.can_knock_back = true
	parent.can_double_jump = true
	super()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:

	if Input.is_action_pressed("pan_cam_down") and Input.is_action_just_pressed("add_currency"):
		parent.pass_through_floor()
		parent.sfx_player.play_sfx(jump_sfx)
		parent.can_double_jump = false
		return fall_state
	
	if _event.is_action_pressed("add_currency"):
		return jump_state
	

	return null

func process_physics(_delta: float) -> State:
	if !GameManager.player_can_move:
		parent.move_and_slide()
		return null

	if Input.is_action_just_pressed("swing_sword"):
		if parent.stored_ore_rock and PlayerStats.facilities_unlocked["Refinery Station"]:
			return swing_pick_axe_state
		return attack_1_state

	# Falling always wins
	if !parent.is_on_floor():
		return fall_state

	# Horizontal movement (continuous)
	var moving := (
		Input.is_action_pressed("pan_cam_left") or
		Input.is_action_pressed("pan_cam_right")
	)

	if moving and GameManager.player_can_move:
		return move_state

	# Ladder logic (continuous)
	if Input.is_action_pressed("pan_cam_up") \
	and parent.in_ladder_area \
	and parent.global_position.y > parent.stored_ladder.ladder_top_position:
		parent.global_position.y -= 7
		return climb_state

	if Input.is_action_pressed("pan_cam_down") \
	and parent.in_ladder_area \
	and parent.global_position.y <= parent.stored_ladder.ladder_top_position:
		parent.global_position.y = parent.stored_ladder.ladder_top_position + 5
		return climb_state

	parent.move_and_slide()
	return null
