class_name PlayerIdle extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State
@export var attack_1_state : State
@export var climb_state : State

func enter() -> void:
	parent.set_sword_texture(animation_name)
	parent.velocity.x = 0
	parent.velocity.y = 0
	super()
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if GameManager.player_can_move:
		var key_pressed: bool = _event.is_action_pressed("pan_cam_left") or _event.is_action_pressed("pan_cam_right")
		
		if key_pressed and parent.is_on_floor():
			return move_state
		
		if Input.is_action_pressed("pan_cam_up") and parent.in_ladder_area and parent.global_position.y > parent.stored_ladder.ladder_top_position:
			parent.global_position.y -= 7
			return climb_state
		
		if Input.is_action_pressed("pan_cam_down") and parent.in_ladder_area  and parent.global_position.y <= parent.stored_ladder.ladder_top_position:
			parent.global_position.y = parent.stored_ladder.ladder_top_position+5
			return climb_state
		
		if Input.is_action_pressed("add_currency"):
			return jump_state
	
		if Input.is_action_pressed("swing_sword"):
			print("BILLBOON!")
			return attack_1_state
		
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if !parent.is_on_floor():
		return fall_state
	
	parent.move_and_slide()
	
	return null
