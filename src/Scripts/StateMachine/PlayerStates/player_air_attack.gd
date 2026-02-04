class_name PlayerAirAttack extends State


@export var idle_state : State
@export var climb_state : State

var equipped_air_attack : AirAttackBehavior

func enter() -> void:
	super()
	parent.can_knock_back = true
	parent.damageable = false
	var selected_class : Dictionary = PlayerStats.player_classes[PlayerStats.player_stats["Class"]]
	equipped_air_attack = selected_class["Air Attack"]
	equipped_air_attack.on_enter(parent)

func exit() -> void:
	parent.damageable = true
	parent.clear_effect_texture()
	stop_player()
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if not parent.is_on_floor():
		var next : State = equipped_air_attack.apply_physics()
		if next != null:
			return next

	if parent.is_on_floor():
		var next : State = equipped_air_attack.on_landing()
		if next != null:
			return next
	

	parent.move_and_slide()
	return null
		

func stop_player() -> void:
	parent.prev_move_speed = 0
	parent.velocity = Vector2.ZERO
