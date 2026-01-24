class_name PlayerJump extends State

@export var idle_state : State
@export var fall_state : State

@export var jump_sfx : AudioStream

func enter() -> void:
	super()
	parent.sfx_player.play_sfx(jump_sfx)
	parent.set_sword_texture(animation_name)
	parent.velocity.y -= PlayerStats.player_stats["Jump Height"]

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis("pan_cam_left","pan_cam_right") * PlayerStats.player_stats["Movement Speed"]
	
	if movement != 0:
		parent.flip_textures(movement < 0)
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	
	if parent.is_on_floor():
		return idle_state
		
	return null
