class_name PlayerSpecialAttack extends State

@export var idle : State

var selected_special_attack : SpecialAttackBehavior

func enter() -> void:
	AbilityTimers.activate_ability_cooldown("Special Attack")
	selected_special_attack = PlayerStats.get_equipped_ability("Special Attack").ability_behavior
	parent.set_sword_texture(selected_special_attack.animation_name)
	parent.set_outfit_texture(selected_special_attack.animation_name)
	parent.animation_player.play(selected_special_attack.animation_name)
	PlayerStats.player_stats["Current MP"] -= PlayerStats.get_equipped_ability("Special Attack").mp_cost
	SignalBus.update_player_mp.emit()
	selected_special_attack.on_enter(parent)
	parent.timer.wait_time = selected_special_attack.animation_duration
	parent.timer.start()
	
func exit() -> void:
	selected_special_attack.on_exit()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	selected_special_attack.apply_physics(_delta)
	if parent.timer.time_left <= 0:
		return idle
	return null
