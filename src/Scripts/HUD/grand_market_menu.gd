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

@onready var ore_bag_label: Label = $OreBagLabel

var selected_item : Item
var selected_inventory : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.populate_market_menu.connect(populate_details_panel)
	init_market()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_details_panel(item : Item, slot_location : String) -> void:
	if item:
		selected_inventory = slot_location
		selected_item = item
		item_icon.texture = selected_item.shop_icon
		item_title.text = selected_item.item_name
		description.text = item.description
		value.text = "Value: %s" % [item.sell_value]
		if item is EnemyDrop:
			match item.item_type:
				item.ITEM_TYPE.COOKING:
					indicator.texture = ITEM_SLOT_COOKING
				item.ITEM_TYPE.NOVELTY:
					indicator.texture = ITEM_SLOT_NOVELTY
				item.ITEM_TYPE.CRAFTING:
					indicator.texture = ITEM_SLOT_CRAFTING
		else:
			indicator.texture = ITEM_SLOT_NA
		
		
		description.text = item.description

func _on_sell_all_button_button_up() -> void:
	sell_all_items(inventory_container, "Inventory")
	sell_all_items(bank_container, "Bank")
	sell_all_items(ore_inventory_container, "Ore Inventory")

func _on_sell_button_button_up() -> void:
	if InventoryManager.remove_item(selected_inventory, selected_item):
		sfx_player.play_sfx(SELL_ITEM)
		TechTreeManager.currency += selected_item.sell_value
		match selected_inventory:
			"Bank":
				InventoryManager.update_grid_container(bank_container, selected_inventory)
			"Inventory":
				InventoryManager.update_grid_container(inventory_container, selected_inventory)
			"Ore Inventory":
				InventoryManager.update_grid_container(ore_inventory_container, selected_inventory)
				
		currency.text = "Currency: %s" % [TechTreeManager.currency]
		if !InventoryManager.search_item("Inventory", selected_item) and !InventoryManager.search_item("Bank", selected_item) and !InventoryManager.search_item("Ore Inventory", selected_item):
			clear_details()
	else:
		clear_details()
	
func clear_details() -> void:
	selected_item = null
	item_icon.texture = null
	item_title.text = "Selected an Item"
	description.text = ""
	value.text = "N/A"
	indicator.texture = null

func _on_close_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()

func init_market() -> void:
	clear_details()
	currency.text = "Currency: %s" % [TechTreeManager.currency]
	InventoryManager.update_grid_container(inventory_container, "Inventory")
	InventoryManager.update_grid_container(ore_inventory_container, "Ore Inventory")
	if PlayerStats.facilities_unlocked["Bank"]:
		sell_all_button.show()
		InventoryManager.update_grid_container(bank_container, "Bank")
	else:
		bank_notice.show()
	
func sell_all_items(container : GridContainer, inventory_name : String) -> void:
	var inventory : Array = InventoryManager.inventories[inventory_name]
	
	while !inventory.is_empty():
		for slot in inventory:
			for i in range(slot["quantity"]):
				InventoryManager.remove_item(inventory_name, slot["item"])
				TechTreeManager.currency += slot["item"].sell_value
				InventoryManager.update_grid_container(container, inventory_name)
				currency.text = "Currency: %s" % [TechTreeManager.currency]
				sfx_player.play_sfx(SELL_ITEM)
				await get_tree().create_timer(0.1).timeout
