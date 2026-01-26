class_name OreRockPhase1 extends State

@export var ore_rock_phase_2 : State

func enter() -> void:
	parent.ore_rock_graphic.frame = 0

func exit() -> void:
	parent.drop_ore_rock()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.health <= int(parent.ore_rock_stats.max_health * 0.75):
		return ore_rock_phase_2
	return null
