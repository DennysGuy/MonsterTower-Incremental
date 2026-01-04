class_name PlayerFall extends State

@export var jump_state : State
@export var move_state : State
@export var idle_state : State

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var movement = Input.get_axis("pan_cam_left","pan_cam_right") * PlayerStats.player_stats["Movement Speed"]
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if Input.is_action_pressed("jump"):
			return jump_state
		else:
			if movement != 0:
				return move_state
			else:
				return idle_state
	
	return null
