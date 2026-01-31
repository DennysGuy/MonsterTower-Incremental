class_name PlayerFall extends State

@export var jump_state : State
@export var move_state : State
@export var idle_state : State
@export var climb_state : State

@export var air_attack : State
func enter() -> void:
	super()
	parent.can_knock_back = true
	parent.set_sword_texture(animation_name)
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("swing_sword") and PlayerStats.facilities_unlocked["Arial Slash"]:
		return air_attack
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var movement = Input.get_axis("pan_cam_left","pan_cam_right") * PlayerStats.player_stats["Movement Speed"]
	
	if movement != 0:
		parent.flip_textures(movement < 0)
	
	parent.prev_move_speed = movement
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if Input.is_action_pressed("pan_cam_up") and parent.in_ladder_area and parent.global_position.y <= parent.stored_ladder.ladder_bottom_position and parent.global_position.y > parent.stored_ladder.ladder_top_position:
		return climb_state
	
	if parent.is_on_floor():
		parent.set_collision_mask_value(5, true)
		if Input.is_action_pressed("jump"):
			return jump_state
		else:
			if movement != 0:
				return move_state
			else:
				return idle_state
	
	return null
