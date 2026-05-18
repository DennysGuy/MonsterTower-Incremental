class_name HeadLasersState extends State


@export var idle_state : State

var bullet_spawn_timer : float

const SPAWN_TIME = 50
const ROBOT_MOVE_3 = preload("uid://cc6lj68x6mp35")

func enter() -> void:
	super()
	parent.play_sfx(ROBOT_MOVE_3)
	parent.timer.wait_time = randi_range(5,10)
	parent.timer.start()
	bullet_spawn_timer = SPAWN_TIME
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	bullet_spawn_timer -= 100 * _delta
	print(bullet_spawn_timer)
	if parent.timer.time_left <= 0:
		return idle_state
	
	if bullet_spawn_timer <= 0:
		parent.spawn_laser_ball()
		bullet_spawn_timer = SPAWN_TIME
	
	
	return null
