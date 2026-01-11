class_name GrandMarketMenu extends Control

@onready var details_panel: Control = $DetailsPanel

@onready var item_icon: TextureRect = $DetailsPanel/ItemIcon
@onready var item_title: Label = $DetailsPanel/ItemTitle
@onready var item_type: Label = $DetailsPanel/ItemType
@onready var value: Label = $DetailsPanel/Value

@onready var inventory_container: GridContainer = $InventoryContainer
@onready var bank_container: GridContainer = $BankContainer
@onready var bank_notice: Label = $BankNotice
@onready var currency: Label = $Currency


var selected_item : Item
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.populate_market_menu.connect(populate_details_panel)
	init_market()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_details_panel(item : Item) -> void:
	if item:
		selected_item = item
		item_icon.texture = selected_item.shop_icon
		item_title.text = selected_item.item_name
		value.text = "Value: %s" % [item.sell_value]
		print("THIS IS THE SELECTED ITEM: %s" % [selected_item.item_name])


func _on_sell_all_button_button_up() -> void:
	pass # Replace with function body.

func _on_sell_button_button_up() -> void:
	if InventoryManager.remove_item("Inventory", selected_item):
		TechTreeManager.currency += selected_item.sell_value
		update_grid_container(inventory_container, "Inventory")
		currency.text = "Currency: %s" % [TechTreeManager.currency]
	else:
		clear_details()
	
func clear_details() -> void:
	selected_item = null
	item_icon.texture = null
	item_title.text = "Selected an Item"
	item_type.text = "N/A"
	value.text = "N/A"

func _on_close_button_up() -> void:
	queue_free()

func init_market() -> void:
	clear_details()
	currency.text = "Currency: %s" % [TechTreeManager.currency]
	update_grid_container(inventory_container, "Inventory")
	if PlayerStats.facilities_unlocked["Bank"]:
		update_grid_container(bank_container, "Bank")
	else:
		bank_notice.show()
	
func update_grid_container(grid_container : GridContainer, inventory : String) -> void:
	clear_grid_container(grid_container)
	
	for num in range(InventoryManager.get_max_bag_slots()):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
		slot.set_as_shop_slot()
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
