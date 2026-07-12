class_name CombatAbility1State extends State


@export var idle : State

@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0

var combat_ability_state : CombatAbilityBehavior

func enter() -> void:
	parent.can_knock_back = false
	parent.damageable = false
	
	AbilityTimers.activate_ability_cooldown("Combat Ability 1")
	var selected_ability : Ability = PlayerStats.get_equipped_ability("Combat Ability 1")
	
	update_mp_visuals(selected_ability)
	
	PlayerHudSignalBus.check_if_can_cast_combat_ability.emit()
	combat_ability_state = selected_ability.ability_behavior
	parent.set_sword_texture(combat_ability_state.animation_name)
	parent.set_outfit_texture(combat_ability_state.animation_name)
	parent.animation_player.play(combat_ability_state.animation_name)
	parent.timer.wait_time = combat_ability_state.animation_duration
	parent.timer.start()
	combat_ability_state.on_enter(parent)
	
	
	
func exit() -> void:
	parent.can_knock_back = true
	parent.damageable = true
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
	
	if parent.timer.time_left <= 0:
		return idle
	
	return null
