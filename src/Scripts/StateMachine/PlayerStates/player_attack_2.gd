class_name PlayerAttack2State extends State

@export var attack3_state : State
@export var idle_state : State
@export var jump_state : State

@export var swing_sfx : AudioStream

@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0
var attack_velocity : float = 0.0

func enter() -> void:
	parent.velocity.x = 120 * GameManager.set_player_box_direction(parent.sprite.flip_h)
	parent.can_knock_back = true
	#parent.hit_box.position.x = 34 * GameManager.set_player_box_direction(parent.player_sprite.flip_h)
	var class_ability  : Ability = PlayerStats.get_equipped_ability("Attack 2")
	animation_name = class_ability.ability_name
	parent.animation_player.play(animation_name)
	
	parent.set_sword_texture("SwordSwing2")
	parent.set_outfit_texture(animation_name)
	parent.timer.wait_time = PlayerStats.get_current_sword().attack_speed
	parent.timer.start()
	
	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_2
	parent.sfx_player.play_sfx(swing,3.0)
	
func exit() -> void:
	parent.can_attack_cancel = false
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		attack_friction * _delta
	)

	parent.move_and_slide()
	
	if !GameManager.player_can_move:
		return idle_state

	if Input.is_action_pressed("pan_cam_left") and parent.can_attack_cancel or Input.is_action_pressed("pan_cam_right") and parent.can_attack_cancel:
		return idle_state
	
	if Input.is_action_pressed("add_currency") and parent.can_attack_cancel:
		return jump_state

	if parent.is_on_floor() and parent.timer.time_left <= 0:
		if Input.is_action_pressed("swing_sword"):
			return attack3_state
		return idle_state

	return null
