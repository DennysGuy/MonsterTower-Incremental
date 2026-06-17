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
	#parent.disable_hurt_box()
	parent.disable_hit_box()
	parent.timer.wait_time = parent.knock_back_wait_time
	parent.timer.start()
	var hit_sfx : AudioStream = parent.enemy_stats.get_random_hit_vox()
	if hit_sfx and GameManager.monster_voices_toggled:
		parent.play_sfx(hit_sfx)
	
	if parent.locked_on:
		parent.remove_stun_marker()
	
	#parent.sfx_player.play_sfx(impacts.pick_random())

func exit() -> void:
	parent.knock_back_direction = 1
	parent.damageable = true
	parent.event_multiplier = 1.0
	if !parent.is_silenced:
		parent.enable_hit_box()
	
	#parent.enable_hurt_box()
		
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
		#will need to figure out how to dynamically set this so that we can account for an assortment of skills
	var direction_vector = (parent.global_position - parent.player.global_position).normalized()
	var direction = GameManager.set_direction(direction_vector.x) * parent.knock_back_direction
	if parent.can_knock_back:
		parent.velocity.x = (direction * parent.enemy_stats.movement_speed + 20) * parent.event_multiplier
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
