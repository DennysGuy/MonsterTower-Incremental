class_name InventoryBag extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var grid_container: GridContainer = $TextureRect/GridContainer
@onready var bag_full: Label = $BagFull

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.update_inventory_bag.connect(update_grid_container)
	init_bag()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init_bag() -> void:
	update_grid_container()

func update_grid_container() -> void:
	texture_rect.texture = PlayerStats.get_bag().texture
	clear_grid_container()
	
	for num in range(InventoryManager.get_max_bag_slots()):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
		var potential_item
		if num < InventoryManager.inventories["Inventory"].size():
			potential_item = InventoryManager.inventories["Inventory"][num]
			
		if potential_item:
			slot.item = potential_item["item"]
			slot.item_icon.texture = potential_item["item"].shop_icon
			slot.show_quantity_label(potential_item["quantity"])
			grid_container.add_child(slot)
		else:
			grid_container.add_child(slot)
	check_if_bag_full()

func check_if_bag_full() -> void:
	if InventoryManager.check_if_inventory_full():
		show_bag_full()
	else:
		hide_bag_full()

func clear_grid_container() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func show_bag_full() -> void:
	bag_full.show()

func hide_bag_full() -> void:
	bag_full.hide()
