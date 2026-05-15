class_name BossIdle extends State

@export var left_arm_slam : State
@export var right_arm_slam : State
@export var left_arm_laser : State
@export var head_lasers : State

var slams : Array[State]

func enter() -> void:
	super()
	slams  = [left_arm_slam, right_arm_slam, left_arm_laser, head_lasers]
	parent.timer.wait_time = randf_range(5,8)
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		var random_slam = slams.pick_random()
		return random_slam
	
	return null
