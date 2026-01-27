extends Node

'''
this array contains the a dictionary such as:
	{
		"item": item resource,
		"quantity: number stored,
	}

'''

@warning_ignore("unused_signal")
signal update_inventory_bag
@warning_ignore("unused_signal")
signal update_bank_inventory
@warning_ignore("unused_signal")
signal populate_market_menu(item : Item, slot_locale : String)

@export var inventories : Dictionary = {
	"Inventory" : [],
	"Bank": []
}

@onready var meta_data : Dictionary = {
	"Inventory" : {
		"Max Slots" : get_max_bag_slots(), #--- replace these with the player stats
		"Max Stack" : get_max_bag_stack(),
	},
	"Bank" : {
		"Max Slots" : get_max_bank_slots(),
		"Max Stack" : get_max_bank_stack()
	}
}

func get_inventory_meta() -> Dictionary:
	return {
		"Inventory": {
			"Max Slots": get_max_bag_slots(),
			"Max Stack": get_max_bag_stack(),
		},
		"Bank": {
			"Max Slots": get_max_bank_slots(),
			"Max Stack": get_max_bank_stack(),
		}
	}

func item_in_recipe(item : Item, recipe : CraftingRecipe) -> bool:
	for resource in recipe.recipe_list:
		for dict_item in resource.keys():
			if item == dict_item:
				return true
	return false

func search_item(inventory_name : String, item : Item) -> bool:
	
	var selected_inventory : Array = inventories[inventory_name]
	
	if selected_inventory.is_empty():
		return false
	
	for slot in selected_inventory:
		if slot["item"] == item:
			return true
	return false

func add_item(inventory_name : String, item : Item, quantity : int = 1) -> bool:
	if not inventories.has(inventory_name):
		return false
		
	var selected_inventory : Array = inventories[inventory_name]
	var max_slots : int = get_inventory_meta()[inventory_name]["Max Slots"]
	var max_stack : int = get_inventory_meta()[inventory_name]["Max Stack"]
	
	#loop through existing entries.. if we find the item in already, attempt to add the quantity to the stack
	for slot in range(selected_inventory.size()):
		if selected_inventory[slot]["item"] == item and (selected_inventory[slot]["quantity"]+quantity) <= max_stack:
			selected_inventory[slot]["quantity"] += quantity
			update_inventories()
			return true
			
	#if the prior code doesn't occur and inventory isn't maxed, we'll add the item
	if selected_inventory.size() < max_slots:
		selected_inventory.append({
			"item": item,
			"quantity": quantity
		})
		update_inventories()
		return true
		
	return false

func remove_item(inventory_name : String, item : Item, quantity : int = 1) -> bool:
	if not inventories.has(inventory_name):
		return false

	var selected_inventory : Array = inventories[inventory_name]

	for slot in selected_inventory:
		if slot["item"] == item:
			slot["quantity"] -= quantity

			if slot["quantity"] <= 0:
				selected_inventory.erase(slot)

			update_inventories()
			return true

	return false

func clear_bag() -> void:
	var bag : Array = inventories["Inventory"]
	for item in bag :
		bag.erase(item)

#this will only run when we know we can remove them.
func remove_resources_from_inventory(recipe_list : Array[Dictionary]) -> void:
	for item in recipe_list:
		for resource in item.keys():
			var needed : int = item[resource]
			print("THIS IS NEEDED AMOUNT: %s" % needed)
			var removed : int = 0

			# Remove from Inventory first
			for i in range(needed):
				if remove_item("Inventory", resource):
					removed += 1
				else:
					break

			# Remove remaining from Bank
			var remaining : int = needed - removed
			for i in range(remaining):
				if remove_item("Bank", resource):
					removed += 1
				else:
					break

func get_max_bank_slots() -> int:
	return int(PlayerStats.player_stats["Max Bank Slots"])

func get_max_bag_slots() -> int:
	print("THIS IS THE CURRENT BAG %s" % [PlayerStats.get_bag().item_bag_name])
	return PlayerStats.get_bag().max_slots

func get_max_bank_stack() -> int:
	return int(PlayerStats.player_stats["Max Bank Stack"])

func get_max_bag_stack() -> int:
	return int(PlayerStats.player_stats["Max Bag Stack"])

func check_if_inventory_full() -> bool:
	var total_inventory_size = get_max_bag_slots() * get_max_bag_stack()
	var inventory = inventories["Inventory"]
	var total_cur_size : int = 0
	
	for item in inventory:
		for i in range(item["quantity"]):
			total_cur_size += 1
	
	return total_cur_size == total_inventory_size

func check_if_bank_full() -> bool:
	var total_inventory_size = get_max_bank_slots() * get_max_bank_stack()
	var bank = inventories["Bank"]
	var total_cur_size : int = 0
	
	for item in bank:
		for i in range(item["quantity"]):
			total_cur_size += 1
	
	return total_cur_size == total_inventory_size

func check_if_can_add_to_inventory(selected_item : Item) -> bool:
	if check_if_bank_full() and check_if_inventory_full():
		return false
	
	if inventories["Inventory"].size() < get_max_bag_slots() or inventories["Bank"].size() < get_max_bank_slots():
		return true
	
	for item in inventories["Inventory"]:
		if selected_item == item["item"]:
			if item["quantity"] < PlayerStats.player_stats["Max Bag Stack"]:
				return true
	
	for item in inventories["Bank"]:
		if selected_item == item["item"]:
			if item["quantity"] < PlayerStats.player_stats["Max Bank Stack"]:
				return true
	
	return false

func update_inventories() -> void:
	update_inventory_bag.emit()
	update_bank_inventory.emit()


func update_grid_container(grid_container : GridContainer, inventory : String, is_shop : bool = true) -> void:
	clear_grid_container(grid_container)
	
	var max_slots : int
	match inventory:
		"Inventory":
			max_slots = InventoryManager.get_max_bag_slots()
		"Bank":
			max_slots = InventoryManager.get_max_bank_slots()
	
	for num in range(max_slots):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
		if is_shop:
			slot.set_as_shop_slot()
		
		if inventory == "Bank":
			slot.set_locale_as_bank()
			
		var potential_item
		if num < InventoryManager.inventories[inventory].size():
			potential_item = InventoryManager.inventories[inventory][num]
			
		if potential_item:
			slot.item = potential_item["item"]
			slot.item_icon.texture = potential_item["item"].shop_icon
			slot.show_quantity_label(potential_item["quantity"])
			slot.set_indicator(potential_item["item"])
			grid_container.add_child(slot)
		else:
			grid_container.add_child(slot)

func clear_grid_container(grid_container : GridContainer) -> void:
	for child in grid_container.get_children():
		child.queue_free()


func calculate_quantity(recipe: CraftingRecipe) -> int:
	var viable_amount := INF
	
	for craft_material in recipe.recipe_list:
		for mat in craft_material.keys():
			var required = craft_material[mat]
			var inventory_amt := get_quantity(mat)

			if inventory_amt < required:
				return 0

			var crafts = inventory_amt / required
			viable_amount = min(viable_amount, crafts)

	return viable_amount


func get_quantity(selected_item : Item) -> int:
	
	var inventory = InventoryManager.inventories["Inventory"]
	var bank = InventoryManager.inventories["Bank"]
	
	var count : int = 0
	for item in inventory:
		if item["item"] == selected_item:
			for i in range(item["quantity"]):
				count += 1
	
	for item in bank:
		if item["item"] == selected_item:
			for i in range(item["quantity"]):
				count += 1
	
	
	return count

func move_inventory_to_bank() -> void:
	var inventory_snapshot = InventoryManager.inventories["Inventory"].duplicate(true)

	for slot in inventory_snapshot:
		var qty = slot["quantity"]
		var item = slot["item"]

		for i in range(qty):
			if add_item("Bank", item):
				remove_item("Inventory", item)
