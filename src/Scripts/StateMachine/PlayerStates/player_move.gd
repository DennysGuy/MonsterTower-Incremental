class_name PlayerMove extends State

@export var jump_state : State
@export var fall_state : State
@export var idle_state : State
@export var dash_attack_state : State

@export var move_sfx : AudioStream

func enter() -> void:
	super()
	parent.set_sword_texture(animation_name)
	parent.sfx_player.play_sfx(move_sfx)

func exit() -> void:
	parent.sfx_player.stop()

func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("add_currency") and parent.is_on_floor() and GameManager.player_can_move:
		return jump_state
	
	if Input.is_action_just_pressed("swing_sword") and PlayerStats.facilities_unlocked["Dash Attack"] and GameManager.player_can_move and parent.can_dash_attack:
		return dash_attack_state
	
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if !GameManager.player_can_move:
		return idle_state
	
	var input = Input.get_axis("pan_cam_left","pan_cam_right")
	var movement = input * PlayerStats.player_stats["Movement Speed"]
	
	if input != 0:
		parent.prev_input = input
	
	if movement != 0:
		parent.flip_textures(movement < 0)
	
	parent.velocity.x = movement
	#set floor snapping for sloped surfaces
	parent.set_floor_snap_length(30)
	parent.apply_floor_snap()
	parent.move_and_slide()

	if movement == 0:
		return idle_state
	
	if !parent.is_on_floor():
		return fall_state	
	return null
