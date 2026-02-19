class_name SwordSoarBehavior extends DoubleJumpBehavior

func on_enter(player : Player) -> void:
	parent = player
	parent.apply_gravity = false
	parent.velocity = Vector2.ZERO
	parent.sfx_player.play_sfx(sfx)
	var tween : Tween = parent.create_tween()
	await tween.tween_property(parent, "velocity:y", -300, 0.5).finished
	parent.state_machine.change_state(parent.idle_state)

func on_exit() -> void:
	parent.apply_gravity = true

func apply_physics(_delta : float) -> State:
	parent.move_and_slide()
	return null
