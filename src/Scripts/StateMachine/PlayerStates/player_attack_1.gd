class_name PlayerAttack1State extends State

@export var attack2_state : State
@export var idle_state : State


func enter() -> void:
	super()
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.is_on_floor() and parent.timer.time_left <= 0:
		if Input.is_action_pressed("swing_sword"):
			return attack2_state
		return idle_state
	return null
		
