class_name  CraftingStationCraft extends State

'''

- When we drop into crafting state we:
	- check if we can craft: do we have enough inventory space? do we have enough resources?
	- if we have enough, we will craft
	- if not we will return to idle state (and clear the description details; disable crafting buttons)
	- once we drop into this state, we will need to let the station know we're crafting, so we don't restart the process..
	- can the player exit the station while crafting? at the beginning definitely no.. later, yes?
		- disable exit button; or if the player does exit, we'll kill the process and the items won't be removed (or maybe they will as penalty?)
			- this makes me think: should we remove the resources before or after - I think for now, we'll remove before. 
			
	
	- when entering this state, the progress bar will be set to the resource's cook time value
	- the progress bar will fill up automatically when in this state
		- once the progress bar is filled, we'll restart the loop if conditions are met, otherwise, we'll reset
'''

@export var idle_state : State

func enter() -> void:
	super()
	parent.is_crafting = true
	#remove resources from inventory --> we can't get into here unless there is enough inventory space/resources
	InventoryManager.remove_resources_from_inventory(parent.stored_recipe.recipe_list)
	parent.populate_recipes_list(parent.selected_tier)
	parent.update_inventories()
	parent.crafting_progress_bar.max_value = parent.stored_recipe.crafting_time
	parent.crafting_progress_bar.value = 0
func exit() -> void:
	parent.is_crafting = false
	parent.crafting_progress_bar.value = 0

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	#check for valid - if not return to idle
	
	#otherwise we're going to craft this baby? shall we just return the state when it fills?
	match parent.station_type:
		parent.STATION_TYPE.COOKING:
			parent.crafting_progress_bar.value += PlayerStats.player_stats["Cooking Speed"]
	
	if parent.crafting_progress_bar.value >= parent.crafting_progress_bar.max_value:
		var num_check = randi_range(0,100)
		if num_check <= parent.stored_recipe.success_rate * 100:
			if !InventoryManager.add_item("Inventory", parent.stored_recipe.output_item):
				InventoryManager.add_item("Bank", parent.stored_recipe.output_item)
			parent.failure_message.hide()
		else:
			parent.failure_message.show()
			
		parent.update_inventories()
		
		if InventoryManager.check_if_can_add_to_inventory(parent.stored_recipe.output_item):
			var quantity : int = InventoryManager.calculate_quantity(parent.stored_recipe)
			if quantity > 0:
				return self #hopefull we restart the cycle
		
		parent.clear_details_panel()
		return idle_state #we'll do this for now just to test
	
	
	return null
