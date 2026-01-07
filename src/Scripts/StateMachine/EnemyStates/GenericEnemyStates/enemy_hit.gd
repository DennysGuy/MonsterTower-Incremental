class_name EnemyHit extends State

@export var idle_state : State
@export var wait_time : float

func enter() -> void:
	super()
	parent.timer.wait_time = wait_time
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		return idle_state
	return null
