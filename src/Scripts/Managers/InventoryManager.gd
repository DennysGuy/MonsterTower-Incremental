extends Node

'''
this array contains the a dictionary such as:
	{
		"item": item resource,
		"quantity: number stored,
	}

'''

@warning_ignore("unused_signal")
signal update_inventory_bag(inventory_name : String)
@warning_ignore("unused_signal")
signal update_bank_inventory
@warning_ignore("unused_signal")
signal populate_market_menu(item : Item, slot_locale : String, slot_index : int)
@warning_ignore("unused_signal")
signal show_open_bag_notice
@warning_ignore("unused_signal")
signal hide_open_bag_notice
@warning_ignore("unused_signal")
signal populate_inventory_description(item : Item, slot_index : int)
@warning_ignore("unused_signal")
signal show_bank_button
@warning_ignore("unused_signal")
signal reset_stored_slot_index

@export var inventories : Dictionary = {
	"Inventory" : [], # all other items go here
	"Ore" : [], 
	"Gem Stones" : [],
	"Use": [],
	"Bank": []
}

@onready var meta_data : Dictionary = {
	"Inventory" : {
		"Max Slots" : get_max_bag_slots("Bag"), #--- replace these with the player stats
		"Max Stack" : get_max_bag_stack("Max Bag Stack"),
	},
	"Bank" : {
		"Max Slots" : get_max_bank_slots(),
		"Max Stack" : get_max_bank_stack()
	}
}

func get_inventory_meta() -> Dictionary:
	return {
		"Inventory": {
			"Max Slots": get_max_bag_slots("Bag"),
			"Max Stack": get_max_bag_stack("Max Bag Stack"),
		},
		"Ore": {
			"Max Slots": get_max_bag_slots("Bag"),
			"Max Stack": get_max_bag_stack("Max Bag Stack"),
		},
		"Gem Stones": {
			"Max Slots": get_max_bag_slots("Bag"),
			"Max Stack": get_max_bag_stack("Max Bag Stack"),
		},
		"Use": {
			"Max Slots": get_max_bag_slots("Bag"),
			"Max Stack": get_max_bag_stack("Max Bag Stack"),
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
	if not item:
		return false
	
	if not inventories.has(inventory_name):
		return false
		
	var selected_inventory : Array = inventories[inventory_name]
	var max_slots : int = get_inventory_meta()[inventory_name]["Max Slots"]
	var max_stack : int = get_inventory_meta()[inventory_name]["Max Stack"]
	
	#loop through existing entries.. if we find the item in already, attempt to add the quantity to the stack
	for slot in range(selected_inventory.size()):
		if selected_inventory[slot]["item"] == item and (selected_inventory[slot]["quantity"]+quantity) <= max_stack:
			selected_inventory[slot]["quantity"] += quantity
			check_for_notification(item)
			update_inventories(item.get_inventory_name())

			QuestManager.increment_task_item_gather_count.emit(item)
			InventoryManager.show_open_bag_notice.emit()
			return true
			
	#if the prior code doesn't occur and inventory isn't maxed, we'll add the item
	if selected_inventory.size() < max_slots:
		selected_inventory.append({
			"item": item,
			"quantity": quantity
		})
		check_for_notification(item)
		update_inventories(item.get_inventory_name())

		QuestManager.increment_task_item_gather_count.emit(item)
		InventoryManager.show_open_bag_notice.emit()
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
			check_for_notification(item)
			update_inventories(item.get_inventory_name())
			return true

	return false

func remove_item_from_slot(slot_index : int, inventory_name : String, quantity : int = 1) -> bool:
	if not inventories.has(inventory_name) or slot_index == -1:
		return false
	
	var selected_inventory : Array = inventories[inventory_name]
	var selected_slot : Dictionary = selected_inventory[slot_index]
	if selected_slot["item"]:
		selected_slot["quantity"] -= quantity
		
		if selected_slot["quantity"] <= 0:
			selected_inventory.erase(selected_slot)
			reset_stored_slot_index.emit()
			check_for_notification(selected_slot["item"])
			update_inventories(inventory_name)

		QuestManager.decrement_task_item_gather_count.emit(selected_slot["item"])
		return true
	
	return false

func remove_novelty_item(inventory_name : String, item : Item) -> bool:
	if not inventories.has(inventory_name):
		return false
	
	if item is EnemyDrop:
		if item.is_novelty():
			remove_item(inventory_name, item)
			return true
	
	return false
	
##TODO: Rewrite to erase every inventory
func clear_bag() -> void:
	var bag : Array = inventories["Inventory"]
	for item in bag :
		bag.erase(item)
		
	SaveManager.save_inventories()

func remove_resources_from_inventory(recipe_list : Array[Dictionary]) -> void:
	for item in recipe_list:
		for resource in item.keys():
			var remaining : int = item[resource]
			
			while remaining > 0:
				if remove_item(resource.get_inventory_name(), resource):
					remaining -= 1
				elif remove_item("Bank", resource):
					remaining -= 1
				else:
					break

func add_resources_to_inventory(recipe_list : Array[Dictionary]) -> void:
	for item in recipe_list:
		for resource in item.keys():
			var remaining : int = item[resource]
			
			while remaining > 0:
				var added := false
				
				if add_item(resource.get_inventory_name(), resource):
					added = true
				elif add_item("Bank", resource):
					added = true
				
				if added:
					remaining -= 1
				else:
					print("Inventory and Bank full for: ", resource)
					break
					
func get_max_bank_slots() -> int:
	return int(PlayerStats.player_stats["Max Bank Slots"])

func get_max_bag_slots(bag : String) -> int:
	return PlayerStats.get_bag(bag).max_slots

func get_max_bank_stack() -> int:
	return int(PlayerStats.player_stats["Max Bank Stack"])

func get_max_bag_stack(bag_stack : String) -> int:
	return int(PlayerStats.player_stats[bag_stack])

func check_for_notification(item : Item) -> void:
	if not item:
		return
	
	if item.is_crafting() or item.is_use():
		SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.CRAFTING)
	elif item.is_cooking():
		SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.COOKING)
	elif item.is_ore():
		SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.SMELTING)

func check_if_inventory_full(inventory_name : String, bag : String, bag_stack : String) -> bool:
	var total_inventory_size = get_max_bag_slots(bag) * get_max_bag_stack(bag_stack)
	var inventory = inventories[inventory_name]
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

func check_if_can_add_to_inventory(selected_item : Item, inventory_name : String,  bag : String, bag_stack : String) -> bool:
	if check_if_bank_full() and check_if_inventory_full(inventory_name, bag ,bag_stack):
		return false
	
	if inventories[inventory_name].size() < get_max_bag_slots(bag) or inventories["Bank"].size() < get_max_bank_slots():
		return true
	
	for item in inventories[inventory_name]:
		if selected_item == item["item"]:
			if item["quantity"] < PlayerStats.player_stats[bag_stack]:
				return true
	
	for item in inventories["Bank"]:
		if selected_item == item["item"]:
			if item["quantity"] < PlayerStats.player_stats["Max Bank Stack"]:
				return true
	
	return false

func update_inventories(inventory_name : String) -> void:
	update_inventory_bag.emit(inventory_name)
	update_bank_inventory.emit()
	SaveManager.save_inventories()

func update_grid_container(grid_container : GridContainer, inventory : String, is_shop : bool = true, inventory_array : Array = []) -> void:
	clear_grid_container(grid_container)
	
	var max_slots : int
	match inventory:
		"Inventory":
			max_slots = get_max_bag_slots("Bag")
		"Ore":
			max_slots = get_max_bag_slots("Bag")
		"Gem Stones":
			max_slots = get_max_bag_slots("Bag")
		"Use":
			max_slots = get_max_bag_slots("Bag")
		"Bank":
			max_slots = get_max_bank_slots()
	
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
			slot.slot_index = num
			print(slot.slot_index)
			slot.item_icon.texture = potential_item["item"].shop_icon
			slot.show_quantity_label(potential_item["quantity"])
			slot.set_indicator(potential_item["item"])
			grid_container.add_child(slot)
		else:
			grid_container.add_child(slot)

func sort_inventory(grid_container : GridContainer, type : Item.ITEM_TYPE, is_shop : bool = false) -> void:
	var inventory_snap_shot : Array = inventories["Inventory"].duplicate()
	var new_inventory : Array = []
	
	for item in inventory_snap_shot:
		if item["item"].item_type == type:
			new_inventory.append(item)

	update_grid_container_filtered(grid_container, new_inventory, is_shop)
	
func update_grid_container_filtered(grid_container : GridContainer, content : Array, is_shop : bool) -> void:
	clear_grid_container(grid_container)
	for item in content:
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
		
		if is_shop:
			slot.set_as_shop_slot()

		slot.item = item["item"]
		slot.item_icon.texture = item["item"].shop_icon
		slot.show_quantity_label(item["quantity"])
		slot.set_indicator(item["item"])
		grid_container.add_child(slot)

func clear_grid_container(grid_container : GridContainer) -> void:
	for child in grid_container.get_children():
		child.queue_free()

func calculate_quantity(recipe: CraftingRecipe) -> int:
	var viable_amount := INF
	
	for craft_material in recipe.recipe_list:
		for mat in craft_material.keys():
			var required = craft_material[mat]
			var inventory_amt
			match mat.item_type:
				mat.ITEM_TYPE.CRAFTING:
					inventory_amt = get_quantity(mat, "Inventory")
				mat.ITEM_TYPE.COOKING:
					inventory_amt = get_quantity(mat, "Inventory")
				mat.ITEM_TYPE.ORE:
					inventory_amt = get_quantity(mat, "Ore")
				mat.ITEM_TYPE.USE:
					inventory_amt = get_quantity(mat, "Use")
					
			if inventory_amt < required:
				return 0

			var crafts = inventory_amt / required
			viable_amount = min(viable_amount, crafts)

	return viable_amount

func get_quantity(selected_item : Item, inventory_name : String) -> int:
	
	var inventory = InventoryManager.inventories[inventory_name]
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

##TODO: Alter this to be able to handle any inventory
func move_inventory_to_bank() -> void:
	#var inventory_snapshot = InventoryManager.inventories["Novelty Items"].duplicate(true)
#
	#for slot in inventory_snapshot:
		#var qty = slot["quantity"]
		#var item = slot["item"]
#
		#for i in range(qty):
			#if add_item("Bank", item):
				#remove_item("Inventory", item)
	#
	#var ore_inventory_snapshot = InventoryManager.inventories["Ore Inventory"].duplicate(true)
#
	#for slot in ore_inventory_snapshot:
		#var qty = slot["quantity"]
		#var item = slot["item"]
#
		#for i in range(qty):
			#if add_item("Bank", item):
				#remove_item("Ore Inventory", item)	
	pass
