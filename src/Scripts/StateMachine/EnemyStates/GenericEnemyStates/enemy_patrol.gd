class_name EnemyPatrol extends State

@export var idle_state: State
@export var chase_state: State

var directions := [-1, 1]
var dir: int = 1

func enter() -> void:
	super()

	dir = directions.pick_random()

	parent.velocity.x = 0
	parent.timer.wait_time = randi_range(2, 5)

	_apply_direction(dir)

	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	# Turn around if about to fall or hit a wall
	if not parent.ground_detector.is_colliding() or parent.wall_detector.is_colliding():
		dir *= -1
		_apply_direction(dir)

	parent.velocity.x = dir * parent.enemy_stats.movement_speed

	parent.set_floor_snap_length(30)
	parent.apply_floor_snap()
	parent.move_and_slide()

	if parent.timer.time_left <= 0.0:
		return idle_state

	return null

func _apply_direction(new_dir: int) -> void:
	parent.ground_detector.position.x = abs(parent.ground_detector.position.x) * new_dir
	parent.wall_detector.position.x = abs(parent.wall_detector.position.x) * new_dir
	parent.wall_detector.target_position.x = abs(parent.wall_detector.target_position.x) * new_dir
	parent.wall_detector.rotation *= new_dir
	parent.wall_detector.force_raycast_update()
	
	parent.prev_dir = new_dir
	parent.sprite.flip_h = new_dir < 0
