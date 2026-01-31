class_name PlayerAttack1State extends State

@export var attack2_state : State
@export var idle_state : State

@export var swing_sfx : AudioStream

func enter() -> void:
	super()
	parent.can_knock_back = true
	#parent.hit_box.position.x = 34 * GameManager.set_player_box_direction(parent.player_sprite.flip_h)
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	parent.velocity = Vector2.ZERO
	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_1
	parent.sfx_player.play_sfx(swing,3.0)

func exit() -> void:

	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if !GameManager.player_can_move:
		return idle_state
	
	if not parent.is_on_floor():
		if parent.prev_move_speed != 0:
			parent.velocity.x = parent.prev_move_speed
	else:
		stop_player()
		
	if parent.is_on_floor() and parent.timer.time_left <= 0:
		
		if Input.is_action_pressed("swing_sword"):
			return attack2_state
		return idle_state
		
	parent.move_and_slide()
	return null
		

func stop_player() -> void:
	parent.prev_move_speed = 0
	parent.velocity = Vector2.ZERO
