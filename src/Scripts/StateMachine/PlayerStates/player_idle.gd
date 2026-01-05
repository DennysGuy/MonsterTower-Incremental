class_name PlayerIdle extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State
func enter() -> void:
	super()
	parent.set_sword_texture(animation_name)
	parent.velocity.x = 0
	parent.velocity.y = 0
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	
	var key_pressed: bool = _event.is_action_pressed("pan_cam_left") or _event.is_action_pressed("pan_cam_right")
	
	if key_pressed and parent.is_on_floor():
		return move_state
	
	if Input.is_action_pressed("add_currency"):
		return jump_state
	
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if !parent.is_on_floor():
		return fall_state
	
	parent.move_and_slide()
	
	return null
