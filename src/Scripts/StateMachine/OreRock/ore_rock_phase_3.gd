class_name OreRockPhase3 extends State

@export var ore_rock_depleted : State

func enter() -> void:
	parent.ore_rock_graphic.frame = 2

func exit() -> void:
	parent.drop_ore_rock()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.health <= 0:
		return ore_rock_depleted
	return null
