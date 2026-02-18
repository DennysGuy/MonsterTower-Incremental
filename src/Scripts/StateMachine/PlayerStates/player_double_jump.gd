class_name PlayerDoubleJump extends State

@export var idle_state : State
@export var fall_state : State

@export var jump_sfx : AudioStream
@export var air_attack : State

var double_jump_state : DoubleJumpBehavior

func enter() -> void:
	super()
	parent.can_double_jump = false
	parent.can_knock_back = true
	AbilityTimers.activate_ability_cooldown("Double Jump")
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	var selected_ability : Ability = PlayerStats.get_equipped_ability("Double Jump")
	double_jump_state = selected_ability.ability_behavior
	double_jump_state.on_enter(parent)
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	#unique -----------------------------
	var next := double_jump_state.apply_physics()
	if next != null:
		return next
	#-------------------------------------
		
	return null
