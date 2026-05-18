class_name RightArmSlam extends State


@export var idle_state : State
const ARM_CHARGE_UP_1 = preload("uid://c6e668us7vkl5")

func enter() -> void:
	super()
	parent.timer.wait_time = 4.0
	parent.play_sfx(ARM_CHARGE_UP_1)
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
