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

@onready var sell_all_button: Button = $SellAllButton
@onready var description: RichTextLabel = $DetailsPanel/Description

@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var indicator: TextureRect = $DetailsPanel/Indicator

@onready var ore_inventory_container: GridContainer = $OreInventoryContainer

const SELL_ITEM = preload("uid://dasd38kajjc2r")
const ITEM_SLOT_COOKING = preload("uid://b6ekacuriin3v")
const ITEM_SLOT_CRAFTING = preload("uid://dbe6piv0wn7lq")
const ITEM_SLOT_NA = preload("uid://blepqdi1qq7bf")
const ITEM_SLOT_NOVELTY = preload("uid://x2hshpeeawjm")

@onready var inventory_label: Label = $InventoryLabel

@onready var novelties_tab: TextureButton = $HBoxContainer/NoveltiesTab
@onready var crafting_tab: TextureButton = $HBoxContainer/CraftingTab
@onready var cooking_tab: TextureButton = $HBoxContainer/CookingTab
@onready var ore_tab: TextureButton = $HBoxContainer/OreTab
@onready var gem_stones_tab: TextureButton = $HBoxContainer/GemStonesTab
@onready var use_tab: TextureButton = $HBoxContainer/UseTab

var selling_all : bool = false
var selling_novelties : bool = false

var selected_item : Item
var selected_inventory : String
var stored_slot_index : int

@onready var sell_tab_button: Button = $SellTabButton
@onready var sell_bank_button: Button = $SellBankButton

@onready var inventory_bg: TextureRect = $InventoryBG
const GRAND_MARKET_MENU_DROPS_BG = preload("uid://b30bdn5uad13v")
const GRAND_MARKET_MENU_GEMS_BG = preload("uid://c17wtr3d835hl")
const GRAND_MARKET_MENU_ORE_BG = preload("uid://mc5wr12ca83a")
const GRAND_MARKET_MENU_USE_BG = preload("uid://chxbefqvlxayh")

@export var tab_buttons : Array[TextureButton] = [novelties_tab, ore_tab, gem_stones_tab, use_tab]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.populate_market_menu.connect(populate_details_panel)
	InventoryManager.reset_stored_slot_index.connect(reset_stored_slot_index)
	GameManager.can_pause_game = false
	QuestManager.check_facility_name.emit("Grand Market")
	init_market()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func populate_details_panel(item : Item, slot_location : String, slot_index : int) -> void:
	if item:
		selected_inventory = slot_location
		selected_item = item
		item_icon.texture = selected_item.shop_icon
		item_title.text = selected_item.item_name
		description.text = item.description
		value.text = "Value: %s" % [item.sell_value]
		stored_slot_index = slot_index
		match item.item_type:
			item.ITEM_TYPE.COOKING:
				indicator.texture = ITEM_SLOT_COOKING
			item.ITEM_TYPE.NOVELTY:
				indicator.texture = ITEM_SLOT_NOVELTY
			item.ITEM_TYPE.CRAFTING:
				indicator.texture = ITEM_SLOT_CRAFTING
			_:
				indicator.texture = ITEM_SLOT_NA

		description.text = item.description

func _on_sell_button_button_up() -> void:
	if InventoryManager.remove_item_from_slot(stored_slot_index, selected_inventory):
		sfx_player.play_sfx(SELL_ITEM)
		TechTreeManager.currency += selected_item.sell_value
		if selected_inventory == "Bank":
			InventoryManager.update_grid_container(bank_container, "Bank")
		else:
			InventoryManager.update_grid_container(inventory_container, selected_inventory)
				
		SaveManager.save_tech_tree_data()		
		currency.text = "Currency: %s" % [TechTreeManager.currency]
		TechTreeManager.update_currency_label.emit()
		if stored_slot_index == -1:
			clear_details()
	else:
		clear_details()
		
	HubManager.check_for_node_purchase.emit()
	
func clear_details() -> void:
	selected_item = null
	item_icon.texture = null
	item_title.text = "Selected an Item"
	description.text = ""
	value.text = "N/A"
	indicator.texture = null

func reset_stored_slot_index() -> void:
	stored_slot_index = -1

func _on_close_button_up() -> void:
	close_out()

func close_out() -> void:
	CutsceneManager.enable_player_functionality()
	CookingManager.can_craft_bar.emit()
	CookingManager.can_craft_dish.emit()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()	

func init_market() -> void:
	clear_details()
	init_tabs()
	selected_inventory = "Inventory"
	inventory_label.text = selected_inventory
	currency.text = "Currency: %s" % [TechTreeManager.currency]
	InventoryManager.update_grid_container(inventory_container, selected_inventory)


	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank")
	else:
		bank_notice.show()

func init_tabs() -> void:
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		use_tab.show()
	
	if PlayerStats.facilities_unlocked["Gem Stone Station"]:
		gem_stones_tab.show()
	
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		ore_tab.show()
		use_tab.show()

func sell_all_items(container : GridContainer, inventory_name : String) -> void:
	var inventory : Array = InventoryManager.inventories[inventory_name]
	disable_tabs_and_buttons()
	while !inventory.is_empty():
		for slot in inventory:
			for i in range(slot["quantity"]):
				InventoryManager.remove_item(inventory_name, slot["item"])
				TechTreeManager.currency += slot["item"].sell_value
				TechTreeManager.update_currency_label.emit()
				InventoryManager.update_grid_container(container, inventory_name)
				currency.text = "Currency: %s" % [TechTreeManager.currency]
				sfx_player.play_sfx(SELL_ITEM)
				SaveManager.save_tech_tree_data()
				await get_tree().create_timer(0.1).timeout
	
	enable_tabs_and_buttons()
	HubManager.check_for_node_purchase.emit()

func sell_slot(container : GridContainer) -> void:
	var inventory : Array = InventoryManager.inventories[selected_inventory]
	var slot = inventory[stored_slot_index]
	var starting_quantity : int = slot["quantity"]
	for i in starting_quantity:
		InventoryManager.remove_item(selected_inventory, slot["item"])
		TechTreeManager.currency += slot["item"].sell_value
		TechTreeManager.update_currency_label.emit()
		InventoryManager.update_grid_container(container, selected_inventory)
		currency.text = "Currency: %s" % [TechTreeManager.currency]
		sfx_player.play_sfx(SELL_ITEM)
		SaveManager.save_tech_tree_data()
		await get_tree().create_timer(0.1).timeout

func _on_sell_novelties_button_2_button_up() -> void:
	sell_all_items(bank_container, "Bank")

func _on_sell_novelties_button_button_up() -> void:
	sell_all_items(inventory_container, selected_inventory)

func enable_tabs_and_buttons() -> void:
	for tab in tab_buttons:
		tab.disabled = false
	sell_tab_button.disabled = false
	sell_bank_button.disabled = false

func disable_tabs_and_buttons() -> void:
	for tab in tab_buttons:
		tab.disabled = true
	sell_tab_button.disabled = true
	sell_bank_button.disabled = true
	

func _on_novelties_tab_button_up() -> void:
	selected_inventory = "Inventory"
	inventory_label.text = "Drops"
	inventory_bg.texture = GRAND_MARKET_MENU_DROPS_BG
	InventoryManager.update_grid_container(inventory_container, selected_inventory)

func _on_ore_tab_button_up() -> void:
	selected_inventory = "Ore"
	inventory_label.text = selected_inventory
	inventory_bg.texture = GRAND_MARKET_MENU_ORE_BG
	InventoryManager.update_grid_container(inventory_container, selected_inventory)

func _on_gem_stones_tab_button_up() -> void:
	selected_inventory = "Gem Stones"
	inventory_bg.texture = GRAND_MARKET_MENU_GEMS_BG
	inventory_label.text = selected_inventory
	InventoryManager.update_grid_container(inventory_container, selected_inventory)

func _on_use_tab_button_up() -> void:
	selected_inventory = "Use"
	inventory_bg.texture = GRAND_MARKET_MENU_USE_BG
	inventory_label.text = selected_inventory
	InventoryManager.update_grid_container(inventory_container, selected_inventory)


func _on_sell_slot_button_button_up() -> void:
	if !selected_item:
		return
	match selected_inventory:
		"Bank":
			sell_slot(bank_container)
		_:
			sell_slot(inventory_container)


func _on_sell_tab_button_button_up() -> void:
	pass # Replace with function body.
