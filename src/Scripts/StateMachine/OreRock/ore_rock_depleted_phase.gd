class_name OreRockDepleted extends State

@onready var ore_rock_area : CollisionShape2D = $"../../OreRockArea/CollisionShape2D"

func enter() -> void:
	parent.arrow_at_ore.hide()
	parent.enemy_health_bar.hide()
	ore_rock_area.disabled = true
	parent.player.stored_ore_rock = null
	parent.ore_rock_graphic.frame = 3
	parent.depleted = true

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:

	return null
