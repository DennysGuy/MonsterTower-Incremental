class_name PlayerSwingPickAxe extends State

@export var idle_state : State

func enter() -> void:
	super()
	parent.set_pickaxe_texture()
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	parent.velocity = Vector2.ZERO

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
