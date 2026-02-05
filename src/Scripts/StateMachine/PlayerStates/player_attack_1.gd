class_name PlayerAttack1State extends State

@export var attack2_state : State
@export var idle_state : State

@export var swing_sfx : AudioStream

# --- Attack movement tuning ---
@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0

var attack_velocity : float = 0.0

func enter() -> void:
	parent.can_knock_back = true

	var class_ability : Ability = PlayerStats.equipped_abilities["Attack 1"]
	animation_name = class_ability.ability_name
	parent.animation_player.play(animation_name)

	parent.set_sword_texture("SwordSwing1")
	parent.timer.wait_time = animation_duration
	parent.timer.start()

	# --- CAPTURE MOMENTUM ---
	attack_velocity = parent.velocity.x

	# Clamp so sprint/dash doesn't slide forever
	attack_velocity = clamp(
		attack_velocity,
		-max_attack_drift,
		max_attack_drift
	)

	parent.velocity.x = attack_velocity

	var swing : AudioStream = PlayerStats.get_sword(
		int(PlayerStats.player_stats["Equipped Sword"])
	).swing_1
	parent.sfx_player.play_sfx(swing, 3.0)

func exit() -> void:
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	# No movement input during attack
	return null

func process_physics(_delta: float) -> State:

	if !GameManager.player_can_move:
		return idle_state

	# --- APPLY FRICTION ONLY ---
	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		attack_friction * _delta
	)

	parent.move_and_slide()

	# --- CHAIN OR EXIT ---
	if parent.timer.time_left <= 0 and parent.is_on_floor():
		if Input.is_action_pressed("swing_sword"):
			return attack2_state
		return idle_state

	return null
