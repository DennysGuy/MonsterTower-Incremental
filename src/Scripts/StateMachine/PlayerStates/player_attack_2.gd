class_name PlayerAttack2State extends State

@export var attack3_state : State
@export var idle_state : State

@export var swing_sfx : AudioStream

func enter() -> void:

	parent.can_knock_back = true
	#parent.hit_box.position.x = 34 * GameManager.set_player_box_direction(parent.player_sprite.flip_h)
	animation_name = PlayerStats.player_classes[PlayerStats.player_stats["Class"]]["Sword Attack 2 Name"]
	parent.animation_player.play(animation_name)
	
	parent.set_sword_texture("SwordSwing2")
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	
	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_2
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
		
	if parent.is_on_floor() and parent.timer.time_left <= 0:
		if Input.is_action_pressed("swing_sword"):
			return attack3_state
		return idle_state

	return null
