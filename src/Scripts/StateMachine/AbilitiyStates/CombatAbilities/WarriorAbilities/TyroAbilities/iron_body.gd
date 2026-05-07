class_name IronBody extends CombatAbilityBehavior


func on_enter(player : Player) -> void:
	parent = player
	parent.damageable = false
	parent.disable_hurt_box()
	parent.stop_player()
	parent.play_sfx(sfx)


func on_exit() -> void:
	parent.enable_hurt_box()
	

func apply_physics(_delta : float) -> State:

	return null
