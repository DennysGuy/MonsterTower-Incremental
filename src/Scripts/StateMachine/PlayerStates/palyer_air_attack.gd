class_name PlayerAirAttack extends State


@export var idle_state : State

func enter() -> void:
	super()
	parent.dash_attack_collision_shape.disabled = false
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_1
	parent.sfx_player.play_sfx(swing,3.0)

func exit() -> void:
	parent.clear_effect_texture()
	parent.dash_attack_collision_shape.disabled = true
	stop_player()
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	parent.issue_attack(parent.dash_attack_hit_box)
	if not parent.is_on_floor():
		if parent.prev_move_speed != 0:
			parent.velocity.x = parent.prev_move_speed
		

	if parent.is_on_floor():
		return idle_state
		
	parent.move_and_slide()
	
	return null
		

func stop_player() -> void:
	parent.prev_move_speed = 0
	parent.velocity = Vector2.ZERO
