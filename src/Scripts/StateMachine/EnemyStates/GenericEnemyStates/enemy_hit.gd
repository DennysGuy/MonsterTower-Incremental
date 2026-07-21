class_name EnemyHit extends State

@export var idle_state : State
@export var chase_state : State
@export var wait_time : float
@export var hurt_buffer_state : State

@export var generic_impact_1 : AudioStream
@export var generic_impact_2 : AudioStream
@export var generic_impact_3 : AudioStream

@onready var impacts : Array[AudioStream] = [generic_impact_1, generic_impact_2, generic_impact_3]

func enter() -> void:
	super()
	#parent.disable_hurt_box()
	parent.disable_hit_box()
	print(parent.knock_back_wait_time)
	parent.timer.wait_time = parent.knock_back_wait_time
	parent.timer.start()
	var hit_sfx : AudioStream = parent.enemy_stats.get_random_hit_vox()
	if hit_sfx and GameManager.monster_voices_toggled:
		parent.play_sfx(hit_sfx)
	
	if parent.locked_on:
		parent.remove_stun_marker()
	
	if parent.name_tag:
		parent.name_tag.show()
	
	#parent.sfx_player.play_sfx(impacts.pick_random())

func exit() -> void:
	parent.knock_back_direction = 1
	parent.damageable = true
	parent.event_multiplier = 1.0

	
	#if parent.is_inside_tree() and is_instance_valid(parent):
	#await get_tree().create_timer(2.0).timeout
	var timer := Timer.new()
	add_child(timer)
	timer.start(3.5)
	await timer.timeout
	timer.queue_free()
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
		print(direction * (parent.enemy_stats.movement_speed + 20))
		parent.velocity.x = (direction * (parent.enemy_stats.movement_speed + 20)) * parent.event_multiplier
		parent.move_and_slide()
	

	if parent.timer.time_left <= 0:
		return hurt_buffer_state
	return null
