class_name LadderDash extends State


var dash_duration : float = 0.15
var dash_timer : float = 0.0

var after_image_timer : float = 0.1
var after_image_interval : float = 0.1
const DASH_ATTACK = preload("uid://girddg3nhreu")

@export var climb_state : State
@export var idle_state : State

func enter() -> void:
	parent.play_sfx(DASH_ATTACK,3.0)
	dash_timer = dash_duration

func exit() -> void:
	parent.prev_input = 0

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	dash_timer -= _delta
	
	after_image_timer -= _delta
	if after_image_timer <= 0:
		parent.spawn_after_image()
		after_image_timer = after_image_interval
	
	parent.velocity.y += 100 * parent.prev_input
	
	if dash_timer <= 0:
		if !parent.stored_ladder:
			return idle_state
		else:
			return climb_state

	parent.move_and_slide()

	return null
