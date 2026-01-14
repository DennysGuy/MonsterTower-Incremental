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

var is_crafting : bool = false
var selected_tier : int = 1
@onready var inventory_full_warning: Label = $InventoryFullWarning

const CRAFTING_MENU = preload("uid://ce4sagacwwdc8")
const SMELTING_MENU = preload("uid://b4ptfqnoq6qly")

@onready var bank_notice: Label = $BankNotice


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = station_name
	update_inventories()
	clear_menu_item_container()
	clear_details_panel()
	
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
	GameManager.player_can_move = true
	get_parent().queue_free()

func _on_start_crafting_button_up() -> void:
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
	
	var can_add_to_inventory : bool = InventoryManager.check_if_can_add_to_inventory(recipe.output_item)
	
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

func update_inventories() -> void:
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container,"Bank",false)
	else:
		bank_notice.show()
		
	InventoryManager.update_grid_container(inventory_container,"Inventory",false )

func clear_menu_item_container() -> void:
	InventoryManager.clear_grid_container(recipes_container)
	InventoryManager.clear_grid_container(ingredients_container)
