class_name CraftingStationCrafting extends State

@export var idle_state : State

const COOKING_SFX = preload("uid://bnslqqjqnb8y2")
const SMELTING_SFX = preload("uid://ds0to3h3m8yir")


func enter() -> void:
	parent.crafting_progressbar.value = 0
	parent.update_quantity_details()
	
	if parent.station_type == parent.STATION_TYPE.COOKING:
		parent.sfx_player.play_sfx(COOKING_SFX)
	else:
		parent.sfx_player.play_sfx(SMELTING_SFX)
	
	
func exit() -> void:
	if parent.crafting_quantity <= 0:
		parent.stored_recipe = null
		parent.crafting_started = false
		parent.hide_crafting_tracker()
	parent.sfx_player.stop()
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	match parent.station_type:
			parent.STATION_TYPE.COOKING:
				parent.crafting_progressbar.value += PlayerStats.player_stats["Cooking Speed"]
			parent.STATION_TYPE.SMELTING:
				parent.crafting_progressbar.value += PlayerStats.player_stats["Smelting Speed"]
			
	if parent.crafting_progressbar.value >= parent.crafting_progressbar.max_value:
		#var num_check = randi_range(0,100)
		#var success_rate : float = parent.stored_recipe.success_rate
		#match parent.station_type:
			#parent.STATION_TYPE.COOKING:
				#success_rate += PlayerStats.player_stats["Cooking Accuracy Bonus"]
			#parent.STATION_TYPE.SMELTING:
				#success_rate += PlayerStats.player_stats["Smelting Accuracy Bonus"]
		
		var item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
		item_interactable.item = parent.stored_recipe.output_item
		item_interactable.icon.texture = parent.stored_recipe.output_item.shop_icon
		item_interactable.global_position = parent.global_position
		parent.play_success_sfx()
		parent.get_parent().add_child(item_interactable)
		
		parent.crafting_quantity -= 1
		
		if parent.crafting_quantity <= 0:
			parent.crafting_progressbar.value = 0
			return idle_state
		else:
			return self
		
	return null
