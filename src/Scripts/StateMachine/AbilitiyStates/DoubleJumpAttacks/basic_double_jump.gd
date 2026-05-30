class_name BasicDoubleJump extends DoubleJumpBehavior


func on_enter(player : Player) -> void:
	parent = player
	parent.velocity.y = 0
	parent.velocity.y -= PlayerStats.player_stats["Double Jump Height"]
	parent.sfx_player.play_sfx(sfx)
	
func apply_physics(_delta : float) -> State:
	if parent.velocity.y > 0:
		return parent.fall_state
	
	if Input.is_action_just_pressed("swing_sword") and PlayerStats.facilities_unlocked["Arial Slash"]:
		return parent.air_attack
	
	if Input.is_action_just_pressed("dash_attack") and PlayerStats.facilities_unlocked["Dash Attack"]:
		return parent.dash_attack
	
	var movement = Input.get_axis("pan_cam_left","pan_cam_right") * PlayerStats.player_stats["Movement Speed"]

	if movement != 0:
		parent.flip_textures(movement < 0)
	
	parent.prev_move_speed = movement
	parent.velocity.x = movement

	parent.move_and_slide()
	
	if parent.is_on_floor():
		return parent.idle_state
	return null
