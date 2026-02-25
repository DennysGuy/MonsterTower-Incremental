class_name SwordDance extends DashAttackBehavior

func on_enter(player : Player) -> void:
	parent = player
	parent.dash_attack_collision_shape.disabled = false
	parent.is_silence_attack = true
	parent.sfx_player.play_sfx(sfx,3.0)

func apply_input() -> void:
	if Input.is_action_just_pressed("swing_sword"):
		parent.attack_buffer_timer = parent.attack_buffer_wait_time

func apply_physics(_delta : float) -> State:
	#parent.issue_attack(parent.dash_attack_hit_box)
	parent.velocity.x = PlayerStats.player_stats["Dash Speed"] * GameManager.set_player_box_direction(parent.sprite.flip_h)
	
	return null

func on_exiting_dash() -> void:
	parent.invincibility_timer.wait_time = 0.5
	parent.invincibility_timer.start()
	parent.dash_attack_collision_shape.disabled = true
	parent.is_silence_attack = false
