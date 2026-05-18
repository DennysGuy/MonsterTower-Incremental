class_name MossyDungeonBossFall extends State

func enter() -> void:
	super()
	parent.disable_hurt_box()
	parent.damageable = false

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	return null
