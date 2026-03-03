class_name CraftingStationTransferResources extends State

@export var crafting_state : State

func enter() -> void:
	GameManager.player_can_move = false
	await parent.move_resources_to_station()
	GameManager.player_can_move = true
	parent.state_machine.change_state(crafting_state)
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
		
