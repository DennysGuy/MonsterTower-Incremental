class_name PlayerIdle extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State
@export var attack_1_state : State
@export var swing_pick_axe_state : State
@export var climb_state : State
@export var special_attack : State

@export_group("Audio")
@export var jump_sfx : AudioStream



func enter() -> void:
	parent.was_on_ledge = true
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.can_knock_back = true
	parent.can_double_jump = true
	super()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency") and parent.is_on_floor():
		parent.jump_buffer_timer = parent.jump_buffer_wait_time

	return null

func process_physics(_delta: float) -> State:
	
	if Input.is_action_pressed("pan_cam_down") and Input.is_action_just_pressed("add_currency"):
		parent.pass_through_floor()
		parent.sfx_player.play_sfx(jump_sfx)
		parent.can_double_jump = false
		return fall_state
		
	if !GameManager.player_can_move:
		parent.move_and_slide()
		return null

	if parent.jump_buffer_timer > 0 and parent.is_on_floor():
		parent.jump_buffer_timer = 0
		return jump_state

	if Input.is_action_just_pressed("swing_sword"):
		if parent.stored_ore_rock and PlayerStats.facilities_unlocked["Refinery Station"]:
			return swing_pick_axe_state
		return attack_1_state
	
	if Input.is_action_just_pressed("special_attack") and PlayerStats.get_equipped_ability("Special Attack") and parent.can_issue_ability("Special Attack"):
		return special_attack
	
	if !parent.is_on_floor():
		parent.was_on_ledge = false
		return fall_state

	var moving := (
		Input.is_action_pressed("pan_cam_left") or
		Input.is_action_pressed("pan_cam_right")
	)

	if moving and GameManager.player_can_move:
		return move_state

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
