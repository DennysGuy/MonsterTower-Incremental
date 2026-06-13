class_name BasicDashAttack extends DashAttackBehavior

func on_enter(player : Player) -> void:
	parent = player
	parent.dash_attack_collision_shape.disabled = false
	parent.play_sfx(sfx,3.0)

func apply_input() -> void:
	pass

func apply_physics(_delta : float) -> State:
	#parent.issue_attack(parent.dash_attack_hit_box)
	parent.velocity.x = PlayerStats.player_stats["Dash Speed"] * GameManager.set_player_box_direction(parent.sprite.flip_h)

	return null

func on_exiting_dash() -> void:
	parent.invincibility_timer.wait_time = 0.5
	parent.invincibility_timer.start()
	parent.dash_attack_collision_shape.disabled = true
