class_name PlayerSwingPickAxe extends State

@export var idle_state : State
@export var pick_axe_swing : AudioStream
@export var attack_1_state : State
@export var move_state : State
@export var jump_state : State
@export var dash_attack_state : State

func enter() -> void:
	super()
	parent.set_pickaxe_texture()
	parent.set_outfit_texture(animation_name)
	parent.set_hat_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	parent.velocity = Vector2.ZERO
	#parent.sfx_player.play_sfx(pick_axe_swing)

func exit() -> void:
	parent.sfx_player.stop()
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	var moving := (
		Input.is_action_pressed("pan_cam_left") or
		Input.is_action_pressed("pan_cam_right")
	)

	if moving:
		return move_state

	if Input.is_action_just_pressed("add_currency") and parent.is_on_floor():
		return jump_state
	
	if Input.is_action_just_pressed("dash_attack") and PlayerStats.facilities_unlocked["Dash"] and parent.can_issue_ability("Dash"):
		return dash_attack_state
	
	if Input.is_action_just_pressed("swing_sword") and GameManager.player_can_attack:
		return attack_1_state
	
	if parent.stored_ore_rock == null:
		return idle_state
	
	if parent.timer.time_left <= 0:
		if !parent.in_mining_area:
			return idle_state
	
	return null
