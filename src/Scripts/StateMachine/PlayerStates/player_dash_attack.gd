class_name PlayerDashAttackState extends State

@export var idle_state : State
@export var attack_1 : State
@export var jump : State
@export var climb_state : State

@export var combat_ability_1 : State
@export var combat_ability_2 : State
@export var combat_ability_3 : State
@export var combat_ability_4 : State

var equipped_dash_attack : DashAttackBehavior

func enter() -> void:
	super()
	parent.apply_gravity = false
	parent.can_knock_back = false
	parent.damageable = false
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.timer.wait_time = PlayerStats.player_stats["Dash Duration"]
	parent.timer.start()
	parent.grab_ladder_buffer_timer = 0
	AbilityTimers.activate_ability_cooldown("Dash Attack")

	var selected_ability : Ability = PlayerStats.get_equipped_ability("Dash Attack")
	PlayerStats.player_stats["Current MP"] -= selected_ability.mp_cost
	PlayerHudSignalBus.update_player_mp.emit()
	equipped_dash_attack = selected_ability.ability_behavior
	equipped_dash_attack.on_enter(parent)

	#-----------------------------

func exit() -> void:
	#unique
	equipped_dash_attack.on_exiting_dash()

	#-------
	#parent.ability_cool_down_timer.wait_time = PlayerStats.player_stats["Dash Cooldown"]
	#parent.ability_cool_down_timer.start()
	parent.clear_effect_texture()
	parent.apply_gravity = true
	#parent.can_dash_attack = false
	
func process_input(_event: InputEvent) -> State:
	
	if Input.is_action_pressed("pan_cam_up") and parent.in_ladder_area and parent.global_position.y <= parent.stored_ladder.ladder_bottom_position and parent.global_position.y > parent.stored_ladder.ladder_top_position:
		return climb_state
	
	if Input.is_action_pressed("swing_sword"):
		parent.set_attack_buffer_timer()
	elif Input.is_action_just_pressed("add_currency"):
		parent.jump_buffer_timer = parent.jump_buffer_wait_time
	#we can probably add the combat ability buffers here
	elif Input.is_action_just_pressed("combat_ability_1") and PlayerStats.get_equipped_ability("Combat Ability 1"):
		if parent.can_issue_ability("Combat Ability 1"):
			parent.attack_friction = 2000
			parent.max_attack_drift = 0
			parent.combat_ability_1_timer = parent.combat_ability_1_wait_time
		else:
			parent.play_denied_sfx()
			
	elif Input.is_action_just_pressed("combat_ability_2") and PlayerStats.get_equipped_ability("Combat Ability 2"): 
			if parent.can_issue_ability("Combat Ability 2"):
				parent.combat_ability_2_timer = parent.combat_ability_2_wait_time
			else:
				parent.play_denied_sfx()
		
	elif Input.is_action_just_pressed("combat_ability_3") and PlayerStats.get_equipped_ability("Combat Ability 3"): 
			if parent.can_issue_ability("Combat Ability 3"):
				parent.combat_ability_3_timer = parent.combat_ability_3_wait_time
			else:
				parent.play_denied_sfx()
		
	elif Input.is_action_just_pressed("combat_ability_4")  and PlayerStats.get_equipped_ability("Combat Ability 4"): 
			if parent.can_issue_ability("Combat Ability 4"):
				parent.combat_ability_4_timer = parent.combat_ability_4_wait_time
			else:
				parent.play_denied_sfx()
		
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	equipped_dash_attack.apply_physics(_delta)

	if parent.timer.time_left <= 0:
		if parent.attack_buffer_timer > 0:
			parent.attack_buffer_timer = 0
			parent.attack_friction = 1000
			return attack_1
		elif parent.jump_buffer_timer > 0:
			parent.jump_buffer_timer = 0
			return jump
		elif parent.combat_ability_1_timer > 0:
			parent.combat_ability_1_timer = 0
			return combat_ability_1
		elif parent.combat_ability_2_timer > 0:
			parent.combat_ability_2_timer = 0
			return combat_ability_2
			
		elif parent.combat_ability_3_timer > 0:
			parent.combat_ability_3_timer = 0
			return combat_ability_3
			
		elif parent.combat_ability_4_timer > 0:
			parent.combat_ability_4_timer = 0
			return combat_ability_4
			
		parent.velocity = Vector2.ZERO
		return idle_state
	
	parent.move_and_slide()
	return null
