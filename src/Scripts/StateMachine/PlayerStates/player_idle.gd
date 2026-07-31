class_name PlayerIdle extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State
@export var attack_1_state : State
@export var punch_state : State
@export var dash_attack_state : State
@export var swing_pick_axe_state : State
@export var climb_state : State
@export var special_attack : State

@export var combat_ability_1 : State
@export var combat_ability_2 : State
@export var combat_ability_3 : State
@export var combat_ability_4 : State

@export_group("Audio")
@export var jump_sfx : AudioStream

var drop_timer : float = 0.0
var drop_wait_time : float = 0.1

func enter() -> void:
	parent.can_knock_back = true
	parent.was_on_ledge = true
	if PlayerStats.get_current_sword():
		print(PlayerStats.player_stats["Equipped Sword"])
		print(PlayerStats.get_current_sword())
		parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.can_knock_back = true
	parent.can_double_jump = true
	#parent.can_dash_attack = true
	parent.velocity = Vector2.ZERO
	drop_timer = drop_wait_time
	super()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency") and parent.is_on_floor():
		parent.jump_buffer_timer = parent.jump_buffer_wait_time

	return null

func process_physics(_delta: float) -> State:
	
	if Input.is_action_pressed("pan_cam_down"):
		
		drop_timer -= _delta
		
		if drop_timer <= 0:
			parent.pass_through_floor()
			parent.sfx_player.play_sfx(jump_sfx)
			parent.can_double_jump = false
			return fall_state
	
	if Input.is_action_just_released("pan_cam_down"):
		drop_timer = drop_wait_time
	
	if !GameManager.player_can_move:
		parent.move_and_slide()
		return null

	if parent.jump_buffer_timer > 0 and parent.is_on_floor():
		parent.jump_buffer_timer = 0
		return jump_state

	if Input.is_action_just_pressed("swing_sword") and GameManager.player_can_attack:
		if PlayerStats.player_stats["Equipped Sword"] == -1:
			return punch_state
		return attack_1_state
	
	if Input.is_action_just_pressed("interact") and parent.in_mining_area and PlayerStats.facilities_unlocked["Refinery Station"]:
		return swing_pick_axe_state
	
	if Input.is_action_just_pressed("dash_attack") and PlayerStats.facilities_unlocked["Dash"] and parent.can_issue_ability("Dash") and GameManager.player_can_move:
		return dash_attack_state
	
	if GameManager.can_issue_abilities:
		if Input.is_action_just_pressed("special_attack") and PlayerStats.get_equipped_ability("Special Attack") and parent.can_issue_ability("Special Attack"):
			return special_attack
		
		if Input.is_action_just_pressed("combat_ability_1") and PlayerStats.get_equipped_ability("Combat Ability 1"):
			if parent.can_issue_ability("Combat Ability 1"):
				return combat_ability_1
			else:
				parent.play_denied_sfx()

		if Input.is_action_just_pressed("combat_ability_2") and PlayerStats.get_equipped_ability("Combat Ability 2"): 
			if parent.can_issue_ability("Combat Ability 2"):
				return combat_ability_2
			else:
				parent.play_denied_sfx()
				
		if Input.is_action_just_pressed("combat_ability_3") and PlayerStats.get_equipped_ability("Combat Ability 3"):
			if parent.can_issue_ability("Combat Ability 3"):
				return combat_ability_3
			else:
				parent.play_denied_sfx()
				
		if Input.is_action_just_pressed("combat_ability_4") and PlayerStats.get_equipped_ability("Combat Ability 4"):
			if parent.can_issue_ability("Combat Ability 4"):
				return combat_ability_4
			else:
				parent.play_denied_sfx()
	
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
		parent.global_position.y = parent.stored_ladder.ladder_top_position + 20
		return climb_state

	parent.move_and_slide()
	return null
