class_name PlayerAirAttack extends State


@export var idle_state : State
@export var climb_state : State

var equipped_air_attack : AirAttackBehavior

func enter() -> void:
	parent.can_knock_back = true
	parent.damageable = false
	
	var selected_ability : Ability = PlayerStats.get_equipped_ability("Air Attack")
	print("THIS IS AIR ATTACK %s" % selected_ability.ability_behavior)
	#PlayerStats.player_stats["Current MP"] -= selected_ability.mp_cost
	#PlayerHudSignalBus.update_player_mp.emit()
	equipped_air_attack = selected_ability.ability_behavior
	
	parent.set_outfit_texture(equipped_air_attack.animation_name)
	parent.set_sword_texture(equipped_air_attack.animation_name)
	parent.set_hat_texture(animation_name)
	parent.animation_player.play(equipped_air_attack.animation_name)
	equipped_air_attack.on_enter(parent)
	AbilityTimers.activate_ability_cooldown("Air Attack")
	
func exit() -> void:
	parent.damageable = true
	parent.clear_effect_texture()
	
	stop_player()
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency"):
		parent.jump_buffer_timer = parent.jump_buffer_wait_time
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if not parent.is_on_floor():
		var next : State = equipped_air_attack.apply_physics(_delta)
		if next != null:
			return next

	if parent.is_on_floor():
		var next : State = equipped_air_attack.on_landing()
		if next != null:
			return next
	
	parent.move_and_slide()
	return null
	
func stop_player() -> void:
	parent.prev_move_speed = 0
	parent.velocity = Vector2.ZERO
