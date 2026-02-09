class_name PlayerDashAttackState extends State

@export var idle_state : State

var equipped_dash_attack : DashAttackBehavior

func enter() -> void:
	super()
	parent.can_knock_back = false
	parent.damageable = false
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = PlayerStats.player_stats["Dash Duration"]
	parent.timer.start()
	#unique
	var selected_ability : Ability = PlayerStats.get_equipped_ability("Dash Attack")
	equipped_dash_attack = selected_ability.ability_behavior
	equipped_dash_attack.on_enter(parent)
	#-----------------------------

func exit() -> void:
	#unique
	equipped_dash_attack.on_exiting_dash()
	#-------
	parent.ability_cool_down_timer.wait_time = PlayerStats.player_stats["Dash Cooldown"]
	parent.ability_cool_down_timer.start()
	parent.clear_effect_texture()
	parent.velocity = Vector2.ZERO
	parent.damageable = true
	parent.can_dash_attack = false
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	equipped_dash_attack.apply_physics()
	if parent.timer.time_left <= 0:
		return idle_state
	
	parent.move_and_slide()
	return null
