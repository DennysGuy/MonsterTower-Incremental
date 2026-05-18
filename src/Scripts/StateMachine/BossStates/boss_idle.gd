class_name BossIdle extends State

@export var left_arm_slam : State
@export var right_arm_slam : State
@export var left_arm_laser : State
@export var head_lasers : State

var slams : Array[State]

var min_time : float
var max_time : float

func enter() -> void:
	super()
	slams  = [left_arm_slam, right_arm_slam, left_arm_laser, head_lasers]
	var health_ratio : int = int((parent.health/parent.enemy_stats.max_health) * 100)
	print(health_ratio)
	if health_ratio >= 70:
		min_time = 5
		max_time = 8
		parent.set_animation_speed()
	elif health_ratio < 70 and health_ratio >= 40:
		min_time = 3
		max_time = 5
		parent.set_animation_speed(1.2)
	elif health_ratio < 40 and health_ratio >= 20:
		min_time = 2
		max_time = 4
		parent.set_animation_speed(1.5)
	else:
		min_time = 1
		max_time = 3
		parent.set_animation_speed(1.8)
		
	parent.timer.wait_time = randf_range(min_time,max_time)
	parent.timer.start()

func exit() -> void:
	parent.set_animation_speed()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		var random_slam = slams.pick_random()
		return random_slam
	
	return null
