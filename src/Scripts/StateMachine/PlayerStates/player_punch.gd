class_name PlayerPunch extends State

@export var idle_state : State
@export var jump_state : State

var attack_velocity : float = 0.0

var can_attack_cancel : bool = false

func enter() -> void:
	animation_name = "Punch"
	parent.animation_player.play(animation_name)
	parent.set_outfit_texture(animation_name)
	
	parent.timer.wait_time = 0.7
	parent.timer.start()
	
	if parent.knocked_back:
		parent.stop_player()
	else:
		# --- CAPTURE MOMENTUM ---
		if int(parent.velocity.x) != 0:
			attack_velocity = parent.velocity.x
			attack_velocity = clamp(
				attack_velocity,
				-parent.max_attack_drift,
				parent.max_attack_drift
			)

			parent.velocity.x = attack_velocity

	# Clamp so sprint/dash doesn't slide forever
	#parent.sfx_player.play_sfx(swing, 3.0)

func exit() -> void:
	parent.can_attack_cancel = false
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:

	if !GameManager.player_can_move:
		return idle_state

	# --- APPLY FRICTION ONLY ---
	
	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		parent.attack_friction * _delta
	)

	parent.move_and_slide()

	if (Input.is_action_pressed("pan_cam_left") or Input.is_action_pressed("pan_cam_right")) and !Input.is_action_pressed("swing_sword") and parent.can_attack_cancel:
		return idle_state
	
	if Input.is_action_pressed("add_currency") and parent.can_attack_cancel:
		return jump_state
	
	# --- CHAIN OR EXIT ---
	if parent.timer.time_left <= 0 and parent.is_on_floor():
		if Input.is_action_pressed("swing_sword"):
			return self
		return idle_state
	return null
