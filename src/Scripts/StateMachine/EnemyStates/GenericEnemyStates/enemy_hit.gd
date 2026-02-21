class_name EnemyHit extends State

@export var idle_state : State
@export var chase_state : State
@export var wait_time : float

@export var generic_impact_1 : AudioStream
@export var generic_impact_2 : AudioStream
@export var generic_impact_3 : AudioStream

@onready var impacts : Array[AudioStream] = [generic_impact_1, generic_impact_2, generic_impact_3]

func enter() -> void:
	super()
	parent.disable_hurt_box()
	parent.timer.wait_time = wait_time
	parent.timer.start()
	parent.sfx_player.play_sfx(impacts.pick_random())

func exit() -> void:
	parent.enable_hurt_box()
	pass
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
		#will need to figure out how to dynamically set this so that we can account for an assortment of skills
	var direction_vector = (parent.global_position - parent.player.global_position).normalized()
	var direction = GameManager.set_direction(direction_vector.x)
	if parent.can_knock_back:
		parent.velocity.x = direction * parent.enemy_stats.movement_speed + 20
		parent.move_and_slide()
	
	if parent.timer.is_stopped():
		#if the enemy is a passive type, don't do anything
		if parent.enemy_stats.is_passive():
			return idle_state
		else:
			return chase_state

	if parent.timer.time_left <= 0:
		return idle_state
	return null
