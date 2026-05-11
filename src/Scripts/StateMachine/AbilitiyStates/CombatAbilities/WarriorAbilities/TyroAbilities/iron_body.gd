class_name IronBody extends CombatAbilityBehavior


func on_enter(player : Player) -> void:
	parent = player
	parent.damageable = false
	parent.disable_hurt_box()
	parent.stop_player()
	parent.play_sfx(sfx)
	var ability_parent : Ability = PlayerStats.get_equipped_ability("Combat Ability 3")
	PlayerStats.defense_buff_mod = ability_parent.defense_modifier
	PlayerStats.knock_back_buff_mod = ability_parent.knock_back_modifier
	AbilityTimers.start_buff_timer_1(ability_parent.buff_limit_time, ability_parent)

func on_exit() -> void:
	parent.enable_hurt_box()
	

func apply_physics(_delta : float) -> State:

	return null
