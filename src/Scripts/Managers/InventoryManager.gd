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

func remove_item(inventory_name : String, item : Item, quantity :int = 1) -> bool:
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

func update_inventories() -> void:
	update_inventory_bag.emit()
	update_bank_inventory.emit()


func update_grid_container(grid_container : GridContainer, inventory : String) -> void:
	clear_grid_container(grid_container)
	
	var max_slots : int
	match inventory:
		"Inventory":
			max_slots = InventoryManager.get_max_bag_slots()
		"Bank":
			max_slots = InventoryManager.get_max_bank_slots()
	
	for num in range(max_slots):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
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
			grid_container.add_child(slot)
		else:
			grid_container.add_child(slot)

func clear_grid_container(grid_container : GridContainer) -> void:
	for child in grid_container.get_children():
		child.queue_free()
