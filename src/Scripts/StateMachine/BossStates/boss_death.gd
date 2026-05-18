class_name BossDeath extends State

const ROBOT_DEATH = preload("uid://xlnchrf2knj0")

func enter() -> void:
	super()
	parent.play_sfx(ROBOT_DEATH)
	ExpeditionTimer.stop_timer()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	return null
