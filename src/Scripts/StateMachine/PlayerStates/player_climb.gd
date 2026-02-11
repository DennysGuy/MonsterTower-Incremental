class_name PlayerClimb extends State

@export var idle_state : State
@export var jump_state : State 

@export var climb_sfx : AudioStream

func enter() -> void:
	super()
	parent.can_double_jump = true
	parent.can_knock_back = false
	parent.velocity = Vector2.ZERO
	if parent.stored_ladder:
		parent.global_position.x = parent.stored_ladder.global_position.x
	parent.is_climbing = true
	parent.set_collision_mask_value(5, false)
	
func exit() -> void:
	
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
	parent.velocity.y = input * PlayerStats.player_stats["Climbing Speed"]
	
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
		return jump_state
	
	
	if parent.global_position.y <= parent.stored_ladder.ladder_top_position and parent.is_climbing:
		return idle_state
	
	if parent.global_position.y >= parent.stored_ladder.ladder_bottom_position and parent.is_climbing:
		return idle_state
	
	parent.move_and_slide()
	
	return null
