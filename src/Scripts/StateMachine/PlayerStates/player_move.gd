class_name PlayerMove extends State

@export var jump_state : State
@export var fall_state : State
@export var idle_state : State
@export var dash_attack_state : State
@export var attack_1_state : State
@export var special_attack : State

@export var move_sfx : AudioStream

# --- Movement tuning ---
@export var accel : float = 2000.0
@export var decel : float = 2400.0
@export var turn_resistance : float = 3000.0

func enter() -> void:
	super()
	parent.was_on_ledge = true
	parent.can_double_jump = true
	parent.can_knock_back = true
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.sfx_player.play_sfx(move_sfx)

func exit() -> void:
	parent.sfx_player.stop()

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency") and parent.is_on_floor():
		parent.jump_buffer_timer = parent.jump_buffer_wait_time
	return null

func process_physics(_delta: float) -> State:
	
	if !GameManager.player_can_move:
		return idle_state
	
	if parent.jump_buffer_timer > 0 and parent.is_on_floor():
		parent.jump_buffer_timer = 0
		return jump_state
	
	if Input.is_action_just_pressed("dash_attack") and PlayerStats.facilities_unlocked["Dash Attack"] and parent.can_issue_ability("Dash Attack"):
		return dash_attack_state

	if Input.is_action_just_pressed("special_attack") and Input.is_action_just_pressed("special_attack") and PlayerStats.get_equipped_ability("Special Attack") and parent.can_issue_ability("Special Attack"):
		return special_attack

	if Input.is_action_just_pressed("swing_sword"):
		parent.attack_friction = 400
		parent.max_attack_drift = 200
		return attack_1_state

	var input := Input.get_axis("pan_cam_left", "pan_cam_right")
	var max_speed = PlayerStats.player_stats["Movement Speed"]
	var target_speed = input * max_speed

	# Remember last facing direction
	if input != 0:
		parent.prev_input = input

	# Flip visuals
	if parent.velocity.x != 0:
		parent.flip_textures(parent.velocity.x < 0)

	# --- FRICTION LOGIC ---

	if input != 0:
		# If changing direction, apply stronger resistance
		if sign(target_speed) != sign(parent.velocity.x) and parent.velocity.x != 0:
			parent.velocity.x = move_toward(
				parent.velocity.x,
				target_speed,
				turn_resistance * _delta
			)
		else:
			parent.velocity.x = move_toward(
				parent.velocity.x,
				target_speed,
				accel * _delta
			)
	else:
		# No input → friction
		parent.velocity.x = move_toward(
			parent.velocity.x,
			0.0,
			decel * _delta
		)

	# Floor snap for slopes
	parent.set_floor_snap_length(30)
	parent.apply_floor_snap()
	parent.move_and_slide()

	# --- State transitions ---
	if !parent.is_on_floor():
		parent.was_on_ledge = false
		return fall_state

	if abs(parent.velocity.x) < 5.0:
		parent.stop_player()
		return idle_state

	return null
