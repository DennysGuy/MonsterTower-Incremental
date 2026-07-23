class_name BasicDashAttack extends DashAttackBehavior

var after_image_timer : float = 0.1
var after_image_interval : float = 0.1

func on_enter(player : Player) -> void:
	parent = player
	parent.dash_attack_collision_shape.disabled = false
	parent.play_sfx(sfx,3.0)

func apply_input() -> void:
	pass

func apply_physics(_delta : float) -> State:
	#parent.issue_attack(parent.dash_attack_hit_box)
	parent.velocity.x = PlayerStats.player_stats["Dash Speed"] * GameManager.set_player_box_direction(parent.sprite.flip_h)
	after_image_timer -= _delta
	if after_image_timer <= 0:
		parent.spawn_after_image()
		after_image_timer = after_image_interval
	
	return null

func on_exiting_dash() -> void:
	parent.invincibility_timer.wait_time = 0.5
	parent.invincibility_timer.start()
	parent.dash_attack_collision_shape.disabled = true
