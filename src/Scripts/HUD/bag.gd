class_name InventoryBag extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var grid_container: GridContainer = $TextureRect/GridContainer
@onready var tab_full: Label = $TextureRect/TabFull

@onready var sfx_player: SFXPlayer = $SfxPlayer
const BAG_FULL = preload("uid://bakwpx4g6fqth")
@onready var item_icon: BagItemIcon = $TextureRect/ItemIcon
@onready var gold_count: Label = $TextureRect/GoldCount

@onready var item_title: Label = $TextureRect/ItemTitle
@onready var description: Label = $TextureRect/Description
@onready var inventory_name: Label = $TextureRect/PanelContainer/MarginContainer/InventoryName

@onready var ore: TextureButton = $TextureRect/HBoxContainer/Ore
@onready var gem_stone_tab: TextureButton = $TextureRect/HBoxContainer/GemStoneTab
@onready var use_tab: TextureButton = $TextureRect/HBoxContainer/UseTab

@onready var filters: HBoxContainer = $TextureRect/Filters
@onready var inventory_tab: TextureButton = $TextureRect/HBoxContainer/InventoryTab
@onready var filters_label: Label = $TextureRect/FiltersLabel

var selected_item : Item
@onready var sell_value: Label = $TextureRect/SellValue

@onready var novelty_tab_label: Label = $TextureRect/HBoxContainer/InventoryTab/NoveltyTabLabel

@onready var craft_tab_label: Label = $TextureRect/HBoxContainer/CraftingTab/CraftTabLabel
@onready var cooking_tab_label: Label = $TextureRect/HBoxContainer/CookingTab/CookingTabLabel

@onready var ore_tab_label: Label = $TextureRect/HBoxContainer/Ore/OreTabLabel
@onready var gem_stone_tab_label: Label = $TextureRect/HBoxContainer/GemStoneTab/GemStoneTabLabel
@onready var use_tab_label: Label = $TextureRect/HBoxContainer/UseTab/UseTabLabel
@onready var show_bank: TextureButton = $TextureRect/HBoxContainer/ShowBank

@onready var tabs : Array[TextureButton] = [inventory_tab, ore, gem_stone_tab, use_tab, show_bank]
@onready var tier_box: HBoxContainer = $TextureRect/TierBox
@onready var bank_container: GridContainer = $Bank/BankContainer
@onready var bank: TextureRect = $Bank


const DROPS_BAG_BG = preload("uid://bot5flcdwi2w3")
const GEMSTONE_BAG_BG = preload("uid://bpmgpuqy6o3dd")

const ORE_BAG_BG = preload("uid://dpbp1fre1iaqg")
const USE_BAG_BG = preload("uid://bt6uswk447ud5")
const CLICK_ON = preload("uid://drj3xu66x5vg")

const DROP_BAG_OPEN = preload("uid://b3s20yo5x604q")
const GEM_BAG_OPEN = preload("uid://c6mxc46l80hvc")
const ORE_BAG_OPEN = preload("uid://b0prhy0pm7hwp")
const USE_BAG_OPEN = preload("uid://caumwm7nf3s0t")
const BUTTON_HOVER = preload("uid://dj4lg3rglma0j")
const DROP = preload("uid://bli85jj3lnefb")
const DROP_ITEM = preload("uid://b1l5d27bgd6wb")
@onready var discard: TextureButton = $TextureRect/Discard

@onready var bag_bg: TextureRect = $TextureRect/BagBG
const DENIED = preload("uid://672acnsycbfo")

var bank_showing : bool = false
@onready var to_bank: TextureButton = $TextureRect/ToBank

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.update_inventory_bag.connect(update_grid_container)
	InventoryManager.populate_inventory_description.connect(update_item_description)
	InventoryManager.show_bank_button.connect(show_to_bank_button)
	init_bag()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_bag() -> void:
	update_bag()
	item_icon.texture = null
	gold_count.text = str(TechTreeManager.currency)
	update_grid_container("Inventory")
	clear_description_items()

func update_grid_container(inventory : String) -> void:
	#texture_rect.texture = PlayerStats.get_bag("Bag").texture
	if inventory == "Inventory":
		inventory_name.text = "Bag Selected: Drops"
		filters_label.show()
	else:
		inventory_name.text = "Bag Selected: "+inventory
		filters_label.hide()
		
	match inventory:
		"Inventory":
			bag_bg.texture = DROPS_BAG_BG
		"Ore":
			bag_bg.texture = ORE_BAG_BG
		"Gem Stones":
			bag_bg.texture = GEMSTONE_BAG_BG
		"Use":
			bag_bg.texture = USE_BAG_BG
		
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
	check_if_bag_full(inventory)
	
	if inventory == "Inventory":
		filters.show()
	else:
		filters.hide()
	

func check_if_bag_full(selected_inventory_name : String) -> void:
	if InventoryManager.check_if_inventory_full(selected_inventory_name, "Bag", "Max Bag Stack"):
		show_bag_full()
		sfx_player.play_sfx(BAG_FULL)
	else:
		hide_bag_full()

func clear_grid_container() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func show_bag_full() -> void:
	tab_full.show()

func hide_bag_full() -> void:
	tab_full.hide()

func disable_tabs() -> void:
	for tab in tabs:
		tab.disabled = true
	discard.disabled = true

func enable_tabs() -> void:
	for tab in tabs:
		tab.disabled = false
	discard.disabled = false

func init_tabs() -> void:
	
	update_tab_label(novelty_tab_label,"Drops", "Inventory")
	
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		use_tab.show()
		update_tab_label(use_tab_label,"Use", "Use")
	
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		ore.show()
		update_tab_label(ore_tab_label,"Ore", "Ore")
		use_tab.show()
		update_tab_label(use_tab_label,"Use", "Use")

	if PlayerStats.facilities_unlocked["Gem Stone Station"]:
		gem_stone_tab.show()
		update_tab_label(gem_stone_tab_label, "Gems", "Gem Stones")

	if PlayerStats.facilities_unlocked["Bank"]:
		show_bank.show()
	else:
		show_bank.hide()

func update_tab_label(tab_label : Label, tab_name : String, selected_inventory_name : String) -> void:
	var inventory_current_size : int = InventoryManager.inventories[selected_inventory_name].size()
	var max_slot : int = InventoryManager.get_max_bag_slots("Bag")
	tab_label.text = tab_name + " %s/%s" % [inventory_current_size,max_slot]

func update_bag() -> void:
	gold_count.text = str(TechTreeManager.currency)
	if InventoryManager.check_if_bank_full():
		to_bank.disabled = true
	init_tabs()
	update_bank_container()

func _on_novelty_tab_button_up() -> void:
	bag_bg.texture = DROPS_BAG_BG
	play_sfx(DROP_BAG_OPEN)
	update_grid_container("Inventory")

func _on_ore_button_up() -> void:
	bag_bg.texture = ORE_BAG_BG
	play_sfx(ORE_BAG_OPEN)
	update_grid_container("Ore")

func _on_gem_stone_tab_button_up() -> void:
	bag_bg.texture = GEMSTONE_BAG_BG
	play_sfx(GEM_BAG_OPEN)
	update_grid_container("Gem Stones")

func _on_use_tab_button_up() -> void:
	bag_bg.texture = USE_BAG_BG
	play_sfx(USE_BAG_OPEN)
	update_grid_container("Use")

func update_item_description(item : Item) -> void:
	if not item:
		return 
		
	item_title.text = item.item_name
	description.text = item.description
	item_icon.texture = item.shop_icon
	selected_item = item
	populate_tier_box(item.item_tier)
	sell_value.text = "Sell Value: %s" % item.sell_value
	
func clear_description_items() -> void:
	item_icon.texture = null
	description.text = ""
	item_title.text = ""
	selected_item = null
	
func _on_discard_button_up() -> void:
	discard_from_inventory()

func discard_from_inventory() -> void:
	if not selected_item:
		return
	play_sfx(DROP_ITEM)
	var item_removed : bool = InventoryManager.remove_item(selected_item.get_inventory_name(), selected_item)
	var item_exists : bool =InventoryManager.search_item(selected_item.get_inventory_name(), selected_item)
	if !item_exists:
		clear_description_items()
	if selected_item:
		update_grid_container(selected_item.get_inventory_name())
	

func populate_tier_box(tier : int) -> void:
	clear_tier_box()
	for num in range(tier):
		var star = preload("uid://cjp8ifo5avha3").instantiate()
		tier_box.add_child(star)

func clear_tier_box() -> void:
	for child in tier_box.get_children():
		child.queue_free()

func _on_crafting_items_button_up() -> void:
	InventoryManager.sort_inventory(grid_container, Item.ITEM_TYPE.CRAFTING)


func _on_cooking_items_button_up() -> void:
	InventoryManager.sort_inventory(grid_container, Item.ITEM_TYPE.COOKING)


func _on_novelty_items_button_up() -> void:
	InventoryManager.sort_inventory(grid_container, Item.ITEM_TYPE.NOVELTY)


func _on_filter_off_button_up() -> void:
	update_grid_container("Inventory")
	
func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func update_bank_container() -> void:
	InventoryManager.clear_grid_container(bank_container)
	
	for num in range(PlayerStats.player_stats["Max Bank Slots"]):
		var slot : ItemSlot = preload("uid://d0s6j8mvikv8c").instantiate()
		slot.set_as_bank_slot()
		var potential_item
		if num < InventoryManager.inventories["Bank"].size():
			potential_item = InventoryManager.inventories["Bank"][num]
			
		if potential_item:
			slot.item = potential_item["item"]
			
			slot.item_icon.texture = potential_item["item"].shop_icon
			slot.show_quantity_label(potential_item["quantity"])
			slot.set_indicator(potential_item["item"])
			
			bank_container.add_child(slot)
		else:
			bank_container.add_child(slot)

func _on_inventory_tab_mouse_entered() -> void:
	play_sfx(BUTTON_HOVER,-4.0)


func _on_ore_mouse_entered() -> void:
	play_sfx(BUTTON_HOVER,-4.0)


func _on_gem_stone_tab_mouse_entered() -> void:
	play_sfx(BUTTON_HOVER,-4.0)


func _on_use_tab_mouse_entered() -> void:
	play_sfx(BUTTON_HOVER,-4.0)


func _on_show_bank_button_up() -> void:
	bank_showing = !bank_showing
	play_sfx(CLICK_ON)
	if bank_showing:
		bank.show()
	else:
		bank.hide()


func show_to_bank_button() -> void:
	to_bank.show()

func _on_to_bank_button_up() -> void:
	if InventoryManager.add_item("Bank", selected_item):
		InventoryManager.remove_item(selected_item.get_inventory_name(), selected_item)
	else:
		play_sfx(DENIED,2)
	if InventoryManager.check_if_bank_full():
		to_bank.disabled = true
	update_bank_container()
