class_name PlayerAttack3State extends State

@export var attack1_state : State
@export var idle_state : State

@export var swing_sfx : AudioStream

func enter() -> void:
	super()
	parent.hit_box.position.x = 34 * GameManager.set_player_box_direction(parent.player_sprite.flip_h)
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	
	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_3
	parent.sfx_player.play_sfx(swing,3.0)
	
func exit() -> void:
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.is_on_floor() and parent.timer.time_left <= 0:
		if Input.is_action_pressed("swing_sword"):
			return attack1_state
		return idle_state
	return null
