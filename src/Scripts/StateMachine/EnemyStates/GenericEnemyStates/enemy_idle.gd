class_name EnemyIdle extends State

@export var patrol_state : State

func enter() -> void:
	super()

	parent.velocity = Vector2.ZERO
	parent.timer.wait_time = randi_range(1,4)
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta : float) -> State:
	if GameManager.enemies_can_move and parent.timer.time_left <= 0:
		return patrol_state
	
	return null
