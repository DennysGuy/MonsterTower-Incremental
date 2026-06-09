class_name PlayerClimb extends State

@export var idle_state : State
@export var jump_state : State 

@export var climb_sfx : AudioStream

@export var come_from_below : bool = false

func enter() -> void:
	super()
	parent.apply_gravity = false
	parent.can_double_jump = true
	parent.can_knock_back = false
	parent.velocity = Vector2.ZERO
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	if parent.stored_ladder:
		parent.global_position.x = parent.stored_ladder.global_position.x
	
	parent.is_climbing = true
	parent.set_collision_mask_value(5, false)
	
func exit() -> void:
	parent.apply_gravity = true
	parent.sfx_player.stop()
	parent.is_climbing = false
	parent.set_collision_mask_value(5, true)

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency"):
		parent.jump_buffer_timer = parent.jump_buffer_wait_time
		
		
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var input : float  =  Input.get_axis("pan_cam_up","pan_cam_down")
	parent.velocity.y = input * (PlayerStats.player_stats["Climbing Speed"] + PlayerStats.get_total_gem_bonus("Climb Speed Bonus")) * GameManager.event_speed_mod
	
	if !parent.stored_ladder:
		return idle_state
	
	if parent.velocity.y == 0:
		parent.animation_player.stop(false)
		parent.sfx_player.stop()
	else:
		if !parent.sfx_player.playing:
			parent.sfx_player.play_sfx(climb_sfx)
		parent.animation_player.play()
	
	if parent.jump_buffer_timer > 0:
		parent.grab_ladder_buffer_timer = parent.grab_ladder_buffer_wait_time
		return idle_state
	
	if parent.ladder_top_position_detector.global_position.y <= parent.stored_ladder.ladder_top.global_position.y and Input.is_action_pressed("pan_cam_up") and parent.is_climbing:
		parent.global_position = parent.stored_ladder.ladder_top.global_position
		return idle_state
	
	if parent.global_position.y >= parent.stored_ladder.ladder_bottom.global_position.y and parent.is_climbing:
		return idle_state
	
	parent.move_and_slide()
	
	return null
