class_name PlayerJump extends State

@export var idle_state : State
@export var fall_state : State

@export var jump_sfx : AudioStream
@export var air_attack : State
@export var double_jump : State
@export var dash_attack : State

func enter() -> void:
	super()
	parent.can_knock_back = true
	parent.sfx_player.play_sfx(jump_sfx)
	parent.set_sword_texture(animation_name)
	parent.set_outfit_texture(animation_name)
	parent.double_jump_buffer = parent.double_jump_buffer_wait_time
	parent.velocity.y = 0
	parent.velocity.y -= (PlayerStats.player_stats["Jump Height"] + PlayerStats.get_total_gem_bonus("Jump Height Bonus") + PlayerStats.get_current_sword().jump_height_bonus)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("add_currency") and PlayerStats.facilities_unlocked["Double Jump"] and parent.can_issue_ability("Double Jump") and parent.can_double_jump and GameManager.can_issue_abilities:
		if parent.double_jump_buffer <= 0:
			parent.jump_buffer_timer = parent.jump_buffer_wait_time
			return double_jump
	return null

func process_frame(_delta: float) -> State:

	return null

func process_physics(_delta: float) -> State:
	if parent.velocity.y > 0:
		return fall_state
	
	if Input.is_action_just_pressed("swing_sword") and PlayerStats.facilities_unlocked["Arial Slash"] and parent.can_issue_ability("Air Attack") and GameManager.can_issue_abilities:
		return air_attack
	
	if Input.is_action_just_pressed("dash_attack") and PlayerStats.facilities_unlocked["Dash"] and parent.can_issue_ability("Dash"):
		print("in jump state: %s"% parent.can_dash_attack)
		return dash_attack
	
	var movement =  (Input.get_axis("pan_cam_left","pan_cam_right") * PlayerStats.player_stats["Movement Speed"] * 1.3)
	
	if movement != 0:
		parent.flip_textures(movement < 0)
	
	parent.prev_move_speed = movement * GameManager.event_speed_mod 
	parent.velocity.x = movement * GameManager.event_speed_mod 
	parent.move_and_slide()
	
	if parent.is_on_floor():
		return idle_state
		
	return null
