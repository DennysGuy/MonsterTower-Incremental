class_name PlayerDashAttackState extends State

@export var idle_state : State
@export var attack_1 : State
@export var jump : State
var equipped_dash_attack : DashAttackBehavior

func enter() -> void:
	super()
	parent.can_knock_back = false
	parent.damageable = false
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.timer.wait_time = PlayerStats.player_stats["Dash Duration"]
	parent.timer.start()
	AbilityTimers.activate_ability_cooldown("Dash Attack")
	#unique
	var selected_ability : Ability = PlayerStats.get_equipped_ability("Dash Attack")
	PlayerStats.player_stats["Current MP"] -= selected_ability.mp_cost
	SignalBus.update_player_mp.emit()
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
	parent.velocity = Vector2.ZERO
	
	#parent.can_dash_attack = false
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("swing_sword"):
		parent.set_attack_buffer_timer()
	elif Input.is_action_just_pressed("add_currency"):
		parent.jump_buffer_timer = parent.jump_buffer_wait_time
	
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	equipped_dash_attack.apply_physics(_delta)

	if parent.timer.time_left <= 0:
		if parent.attack_buffer_timer > 0:
			parent.attack_buffer_timer = 0
			return attack_1
		elif parent.jump_buffer_timer > 0:
			parent.jump_buffer_timer = 0
			return jump
		return idle_state
	
	parent.move_and_slide()
	return null
