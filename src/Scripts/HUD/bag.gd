class_name InventoryBag extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var grid_container: GridContainer = $TextureRect/GridContainer
@onready var bag_full: Label = $BagFull
@onready var sfx_player: SFXPlayer = $SfxPlayer
const BAG_FULL = preload("uid://bakwpx4g6fqth")
@onready var item_icon: BagItemIcon = $TextureRect/ItemIcon
@onready var gold_count: Label = $TextureRect/GoldCount

@onready var item_title: Label = $TextureRect/ItemTitle
@onready var description: Label = $TextureRect/Description
@onready var inventory_name: Label = $TextureRect/InventoryName

var selected_item : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.update_inventory_bag.connect(update_grid_container)
	InventoryManager.populate_inventory_description.connect(update_item_description)
	init_bag()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init_bag() -> void:
	item_icon.texture = null
	gold_count.text = str(TechTreeManager.currency)
	update_grid_container("Novelty Items")
	clear_description_items()

func update_grid_container(inventory : String) -> void:
	#texture_rect.texture = PlayerStats.get_bag("Bag").texture
	inventory_name.text = inventory
	clear_grid_container()
	
	for num in range(InventoryManager.get_max_bag_slots("Bag")):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
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
	check_if_bag_full()

func check_if_bag_full() -> void:
	#if InventoryManager.check_if_inventory_full("Inventory", "Bag", "Max Bag Stack"):
		#show_bag_full()
		#sfx_player.play_sfx(BAG_FULL)
	#else:
		#hide_bag_full()
	pass
func clear_grid_container() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func show_bag_full() -> void:
	bag_full.show()

func hide_bag_full() -> void:
	bag_full.hide()


func _on_novelty_tab_button_up() -> void:
	update_grid_container("Novelty Items")


func _on_cooking_tab_button_up() -> void:
	update_grid_container("Cooking Items")


func _on_crafting_tab_button_up() -> void:
	update_grid_container("Crafting Items")


func _on_ore_button_up() -> void:
	update_grid_container("Ore")


func _on_gem_stone_tab_button_up() -> void:
	update_grid_container("Gem Stones")


func update_item_description(item : Item) -> void:
	if not item:
		return 
		
	item_title.text = item.item_name
	description.text = item.description
	item_icon.texture = item.shop_icon
	selected_item = item

func _on_use_tab_button_up() -> void:
	update_grid_container("Use")


func clear_description_items() -> void:
	item_icon.texture = null
	description.text = ""
	item_title.text = ""
	selected_item = null
	
func _on_discard_button_up() -> void:
	if not selected_item:
		return
		
	var item_removed : bool = InventoryManager.remove_item(selected_item.get_inventory_name(), selected_item)
	var item_exists : bool =InventoryManager.search_item(selected_item.get_inventory_name(), selected_item)
	if !item_exists:
		clear_description_items()
	if selected_item:
		update_grid_container(selected_item.get_inventory_name())
