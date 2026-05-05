class_name CombatAbilityState4 extends State


@export var idle_state : State

var combat_ability_state : CombatAbilityBehavior

func enter() -> void:
	AbilityTimers.activate_ability_cooldown("Combat Ability 4")

	var selected_ability : Ability = PlayerStats.get_equipped_ability("Combat Ability 4")
	PlayerStats.player_stats["Current MP"] -= selected_ability.mp_cost
	PlayerHudSignalBus.update_player_mp.emit()
	combat_ability_state = selected_ability.ability_behavior
	parent.set_sword_texture(combat_ability_state.animation_name)
	parent.set_outfit_texture(combat_ability_state.animation_name)
	parent.animation_player.play(combat_ability_state.animation_name)
	combat_ability_state.on_enter(parent)
	
func exit() -> void:
	parent.clear_effect_texture()
	#parent.disable_hit_box()
	combat_ability_state.on_exit()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	#unique -----------------------------
	var next := combat_ability_state.apply_physics(_delta)
	if next != null:
		return next
	#-------------------------------------
		
	return null
