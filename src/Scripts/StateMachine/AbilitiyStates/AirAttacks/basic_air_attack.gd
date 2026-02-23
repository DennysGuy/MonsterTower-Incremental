class_name BasicAirAttack extends AirAttackBehavior

func on_enter(player : Player) -> void:
	parent = player
	#unique
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	#unique
	var swing : AudioStream = sfx
	parent.sfx_player.play_sfx(swing,3.0)

func apply_physics(_delta : float) -> State:
		if parent.jump_buffer_timer > 0 and parent.is_on_floor():
			parent.jump_buffer_timer = 0
			return parent.jump_state
		
		if parent.prev_move_speed != 0:
			parent.velocity.x = parent.prev_move_speed
		if parent.velocity.y > 0:
			if Input.is_action_pressed("pan_cam_up") and parent.in_ladder_area and parent.global_position.y <= parent.stored_ladder.ladder_bottom_position and parent.global_position.y > parent.stored_ladder.ladder_top_position:
				return parent.climb_state
		return null
		
func on_landing() -> State:
	return parent.idle_state
	
