class_name PlayerDoubleJump extends State

@export var idle_state : State
@export var fall_state : State

@export var jump_sfx : AudioStream
@export var air_attack : State

var double_jump_state : DoubleJumpBehavior

func enter() -> void:
	parent.can_double_jump = false
	parent.can_knock_back = true
	AbilityTimers.activate_ability_cooldown("Double Jump")

	var selected_ability : Ability = PlayerStats.get_equipped_ability("Double Jump")
	double_jump_state = selected_ability.ability_behavior
	parent.set_sword_texture(double_jump_state.animation_name)
	parent.set_outfit_texture(double_jump_state.animation_name)
	parent.animation_player.play(double_jump_state.animation_name)
	double_jump_state.on_enter(parent)
	
func exit() -> void:
	parent.clear_effect_texture()
	double_jump_state.on_exit()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	#unique -----------------------------
	var next := double_jump_state.apply_physics(_delta)
	if next != null:
		return next
	#-------------------------------------
		
	return null
