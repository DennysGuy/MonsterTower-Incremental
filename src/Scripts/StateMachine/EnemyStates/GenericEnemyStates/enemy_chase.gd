class_name EnemyChase extends State

@export var idle_state : State
@export var chase_time : float
var dir_vector : Vector2
var direction : int

func enter() -> void:
	super()
	parent.timer.wait_time = chase_time
	parent.timer.start()
	
	dir_vector = (parent.player.global_position - parent.global_position).normalized()
	direction = GameManager.set_direction(dir_vector.x)
	
	parent.apply_direction(direction)
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	if parent.timer.time_left == 0:
		return self
	return null

func process_physics(_delta: float) -> State:
	
	if !parent.ground_detector.is_colliding() or parent.wall_detector.is_colliding():
		return idle_state

	parent.velocity.x = direction * parent.enemy_stats.chase_speed

	parent.move_and_slide()

	return null
		
func set_animation_name(animation_name : String):
	self.animation_name = animation_name
