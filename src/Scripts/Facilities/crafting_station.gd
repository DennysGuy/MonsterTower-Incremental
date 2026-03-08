class_name CraftingStation extends Control

@export var station_name : String
@onready var title: Label = $Title

enum STATION_TYPE {COOKING, SMELTING}
@export var station_type : STATION_TYPE = STATION_TYPE.COOKING

@onready var inventory_container: GridContainer = $InventoryContainer
@onready var bank_container: GridContainer = $BankContainer

@onready var recipes_container: GridContainer = $RecipePanel/RecipesContainer
@onready var ingredients_container: GridContainer = $DetailsPanel/IngredientsContainer

@onready var start_crafting: Button = $StartCrafting
@onready var stop_crafting: Button = $StopCrafting

@export var stored_recipe : CraftingRecipe
@onready var recipe_name: Label = $RecipeName
@onready var level: Label = $Level
@onready var sell_value: Label = $SellValue
@onready var can_make: Label = $CanMake
@onready var success_rate: Label = $SuccessRate
@onready var recipe_icon: TextureRect = $CraftingIconPanel/RecipeIcon
@onready var crafting_progress_bar: TextureProgressBar = $CraftingIconPanel/CraftingProgressBar
@onready var menu_graphic: TextureRect = $MenuGraphic

@onready var failure_message: Label = $FailureMessage

@onready var description: RichTextLabel = $DetailsPanel/Description

@export var state_machine : StateMachine
@export var idle_state : State
@export var crafting_state : State
@onready var selected_tab_label: Label = $SelectedTabLabel

var selected_tab : String

var is_crafting : bool = false
var selected_tier : int = 1
@onready var inventory_full_warning: Label = $InventoryFullWarning

@onready var sfx_player_2: SFXPlayer = $SfxPlayer2

const CRAFTING_MENU = preload("uid://ce4sagacwwdc8")
const SMELTING_MENU = preload("uid://b4ptfqnoq6qly")

const FAILURE = preload("uid://cv5p7ufgqluno")
const SUCCESS = preload("uid://dj3e1mi4ks8sr")

@onready var bank_notice: Label = $BankNotice
@onready var sfx_player: SFXPlayer = $SfxPlayer

@onready var resource_tab_label: Label = $ResourceTab/ResourceTabLabel
@onready var item_added_label: TextureRect = $ItemAddedLabel
@onready var item_removed_label: TextureRect = $ItemRemovedLabel

var show_can_craft_next_sword_scene : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = station_name
	GameManager.can_pause_game = false
	update_inventories()
	clear_menu_item_container()
	clear_details_panel()
	populate_recipes_list(1)
	
	match station_type:
		STATION_TYPE.COOKING:
			menu_graphic.texture = CRAFTING_MENU
		STATION_TYPE.SMELTING:
			menu_graphic.texture = SMELTING_MENU
	
	CookingManager.populate_description_panel.connect(populate_details_panel)
	state_machine.init(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _on_i_button_up() -> void:
	selected_tier = 1
	populate_recipes_list(1)

func _on_ii_button_up() -> void:
	pass # Replace with function body.

func _on_iii_button_up() -> void:
	pass # Replace with function body.

func _on_iv_button_up() -> void:
	pass # Replace with function body.

func _on_exit_button_up() -> void:
	close_out()

func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	if station_type == STATION_TYPE.SMELTING:
		if show_can_craft_next_sword_scene:
			SignalBus.issue_can_craft_sword_scene.emit()
			show_can_craft_next_sword_scene = false
	CookingManager.can_craft_bar.emit()
	CookingManager.can_craft_dish.emit()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	get_parent().queue_free()

func _on_start_crafting_button_up() -> void:
	if !is_crafting:
		state_machine.change_state(crafting_state)

func _on_stop_crafting_button_up() -> void:
	state_machine.change_state(idle_state)

func populate_recipes_list(tier : int) -> void:
	InventoryManager.clear_grid_container(recipes_container)
	var recipe_list : Array 
	match station_type:
		STATION_TYPE.COOKING:
			recipe_list = CookingManager.cooking_recipes[tier]
		STATION_TYPE.SMELTING:
			recipe_list = CookingManager.smelting_recipes[tier]
	
	for recipe in recipe_list :
		var recipe_resource : CraftingRecipe = recipe
		
		var recipe_menu_item : MenuRecipePanel = preload("uid://ukimvty3lrab").instantiate()
		recipe_menu_item.recipe = recipe
		recipe_menu_item.recipe_icon.texture = recipe_resource.menu_icon
		recipe_menu_item.title.text = recipe_resource.recipe_name
		recipe_menu_item.can_make.text = "Can Make: %s" % [InventoryManager.calculate_quantity(recipe)]
		recipes_container.add_child(recipe_menu_item)

func play_success_sfx() -> void:
	sfx_player_2.play_sfx(SUCCESS)

func play_failure_sfx() -> void:
	sfx_player_2.play_sfx(FAILURE)
	
func populate_details_panel(recipe : CraftingRecipe) -> void:
	stored_recipe = recipe
	recipe_name.text = recipe.recipe_name
	level.text = "Tier %s" % [recipe.recipe_tier]
	recipe_icon.texture = recipe.menu_icon
	description.text = recipe.description
	sell_value.text = "Sell Value %s" % [recipe.output_item.sell_value]
	var quantity : int = InventoryManager.calculate_quantity(recipe)
	can_make.text = "Can Make %s" % [quantity]
	success_rate.text = "Success Rate " + str(int(recipe.success_rate*100)) + "%"
	match station_type:
		STATION_TYPE.COOKING: success_rate.text += " (+"+str(int(PlayerStats.player_stats["Cooking Accuracy Bonus"] * 100)) +"%"
		STATION_TYPE.SMELTING: success_rate.text += " (+"+str(int(PlayerStats.player_stats["Smelting Accuracy Bonus"] * 100)) +"%"
	
	var can_add_to_inventory : bool
	
	can_add_to_inventory = InventoryManager.check_if_can_add_to_inventory(recipe.output_item, "Use", "Bag","Max Bag Stack")

	if !can_add_to_inventory:
		inventory_full_warning.show()
	else:
		inventory_full_warning.hide()
	
	if  can_add_to_inventory and quantity > 0:
		start_crafting.disabled = false
		stop_crafting.disabled = false
	else:
		start_crafting.disabled = true
		stop_crafting.disabled = false
	
	InventoryManager.clear_grid_container(ingredients_container)
	
	for ingredient in recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
		
		ingredients_container.add_child(ingredient_menu_item)

func clear_details_panel() -> void:
	stored_recipe = null
	recipe_name.text = "Select a Recipe"
	level.text = ""
	recipe_icon.texture = null
	description.text = ""
	sell_value.text = ""
	can_make.text = ""
	success_rate.text = ""
	InventoryManager.clear_grid_container(ingredients_container)

func update_bank_container() -> void:
	InventoryManager.update_grid_container(bank_container, "Bank")

func update_inventories() -> void:
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container,"Bank",false)
	else:
		bank_notice.show()
	
	if station_type == STATION_TYPE.COOKING:
		resource_tab_label.text = "Inventory"
		InventoryManager.update_grid_container(inventory_container,"Inventory",false )
	elif station_type == STATION_TYPE.SMELTING:
		resource_tab_label.text = "Ore"
		InventoryManager.update_grid_container(inventory_container,"Ore",false )

	selected_tab = "Resource"

func clear_menu_item_container() -> void:
	InventoryManager.clear_grid_container(recipes_container)
	InventoryManager.clear_grid_container(ingredients_container)

func switch_to_use_tab() -> void:
	selected_tab = "Use"
	selected_tab_label.text = "Tab - Use"
	InventoryManager.update_grid_container(inventory_container, "Use")

func _on_resource_tab_button_up() -> void:
	if station_type == STATION_TYPE.COOKING:
		selected_tab_label.text = "Tab - Cooking"
		InventoryManager.update_grid_container(inventory_container, "Inventory")
	elif station_type == STATION_TYPE.SMELTING:
		selected_tab_label.text = "Tab - Ore"
		InventoryManager.update_grid_container(inventory_container, "Ore")
	item_removed_label.hide()
	selected_tab = "Resource"

func _on_use_tab_button_up() -> void:
	selected_tab_label.text = "Tab - Use"
	InventoryManager.update_grid_container(inventory_container, "Use")
	item_added_label.hide()
	selected_tab = "Use"


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
