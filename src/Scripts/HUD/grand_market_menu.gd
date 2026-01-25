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

@onready var sfx_player: SFXPlayer = $SfxPlayer


const SELL_ITEM = preload("uid://dasd38kajjc2r")


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
		value.text = "Value: %s" % [item.sell_value]
		print("THIS IS THE SELECTED ITEM: %s" % [selected_item.item_name])


func _on_sell_all_button_button_up() -> void:
	sell_all_items(inventory_container, "Inventory")
	sell_all_items(bank_container, "Bank")

func _on_sell_button_button_up() -> void:
	print(selected_inventory)
	if InventoryManager.remove_item(selected_inventory, selected_item):
		sfx_player.play_sfx(SELL_ITEM,0,true)
		TechTreeManager.currency += selected_item.sell_value
		match selected_inventory:
			"Bank":
				InventoryManager.update_grid_container(bank_container, selected_inventory)
			"Inventory":
				InventoryManager.update_grid_container(inventory_container, selected_inventory)
		currency.text = "Currency: %s" % [TechTreeManager.currency]
		if !InventoryManager.search_item("Inventory", selected_item) and !InventoryManager.search_item("Bank", selected_item):
			clear_details()
	else:
		clear_details()
	
func clear_details() -> void:
	selected_item = null
	item_icon.texture = null
	item_title.text = "Selected an Item"
	item_type.text = "N/A"
	value.text = "N/A"

func _on_close_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()

func init_market() -> void:
	clear_details()
	currency.text = "Currency: %s" % [TechTreeManager.currency]
	InventoryManager.update_grid_container(inventory_container, "Inventory")
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
