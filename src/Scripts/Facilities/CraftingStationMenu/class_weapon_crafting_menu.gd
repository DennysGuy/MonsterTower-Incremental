class_name ClassWeaponCraftingMenu extends Control


#Inventory Side
@onready var bag_bg: TextureRect = $Inventory/BagBG
@onready var inventory_title: Label = $Inventory/InventoryTitle

@onready var inventory_container: GridContainer = $Inventory/InventoryContainer
@onready var bank_container: GridContainer = $Inventory/BankContainer
@onready var bank_account_locked_notice: Label = $Inventory/BankAccountLockedNotice

#Description Side
@onready var weapon_name: Label = $DescriptionPanel/WeaponName
@onready var description_label: RichTextLabel = $DescriptionPanel/DescriptionPanel/DescriptionLabel
@onready var ingredients_container: GridContainer = $DescriptionPanel/IngredientsContainer
@onready var stat_bonuses_label: RichTextLabel = $DescriptionPanel/StatBonusesLabel
@onready var description_panel: TextureRect = $DescriptionPanel

#Weapon Menu Side
@onready var warrior_weapon_container: GridContainer = $ForeGround/WarriorWeaponContainer
@onready var weapon_mold_graphic: TextureRect = $ForeGround/WeaponMoldGraphic
@onready var action_button: Button = $ForeGround/ActionButton

@export var stored_weapon : Sword

const GEAR_STATION_DROPS_BAG_BG = preload("uid://dqrwhfhixd1io")
const GEAR_STATION_USE_BAG_BG = preload("uid://b5o4unayrrfi")

var selected_bag : String = "Drops"

var description_panel_showing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.populate_weapon_description_panel.connect(select_weapon)
	update_inventory_containers()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_action_button_button_up() -> void:
	pass # Replace with function body.

func exit_menu() -> void:
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true

	queue_free()

func _on_drops_bag_button_button_up() -> void:
	show_inventory("Drops")

func _on_use_bag_button_button_up() -> void:
	show_inventory("Use")

func update_inventory_containers() -> void:
	show_inventory(selected_bag)
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank",false)
	else:
		bank_account_locked_notice.show()

func show_inventory(bag_name : String) -> void:
	match bag_name:
		"Drops":
			bag_bg.texture = GEAR_STATION_DROPS_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Inventory", false)
			selected_bag = "Drops"
		"Use":
			bag_bg.texture = GEAR_STATION_USE_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Use", false)
			selected_bag = "Use"
			
	selected_bag = bag_name
	inventory_title.text = bag_name

func select_weapon(weapon : Sword) -> void:
	stored_weapon = weapon
	weapon_name.text = stored_weapon.sword_name
	description_label.text = stored_weapon.description
	stat_bonuses_label.text = stored_weapon.get_stats_description()
	populate_ingredients_list(stored_weapon)
	if !description_panel_showing:
		show_description_panel()

func show_description_panel() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(description_panel, "position",Vector2(176,64),0.1)
	await tween.finished
	description_panel_showing = true

func hide_description_panel() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(description_panel, "position",Vector2(640,64),0.1)
	await tween.finished
	description_panel_showing = false

func populate_ingredients_list(weapon : Sword) -> void:
	InventoryManager.clear_grid_container(ingredients_container)
	for ingredient in weapon.recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
			
		ingredients_container.add_child(ingredient_menu_item)
