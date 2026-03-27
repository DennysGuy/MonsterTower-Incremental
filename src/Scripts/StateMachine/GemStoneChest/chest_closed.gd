class_name GemStoneChestClosed extends State

@export var opened_state : State

func enter() -> void:
	parent.set_graphic_closed()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.health <= 0:
		return opened_state
	return null
		
func set_animation_name(animation_name : String):
	self.animation_name = animation_name
