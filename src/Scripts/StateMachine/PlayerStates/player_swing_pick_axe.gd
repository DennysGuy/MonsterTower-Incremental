class_name PlayerSwingPickAxe extends State

@export var idle_state : State
@export var pick_axe_swing : AudioStream

func enter() -> void:
	super()
	parent.set_pickaxe_texture()
	parent.set_outfit_texture(animation_name)
	parent.timer.wait_time = animation_duration
	parent.timer.start()
	parent.velocity = Vector2.ZERO
	#parent.sfx_player.play_sfx(pick_axe_swing)

func exit() -> void:
	parent.sfx_player.stop()
	parent.clear_effect_texture()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.stored_ore_rock == null:
		return idle_state
	
	if parent.timer.time_left <= 0:
		if !Input.is_action_pressed("swing_sword"):
			return idle_state
	
	return null
