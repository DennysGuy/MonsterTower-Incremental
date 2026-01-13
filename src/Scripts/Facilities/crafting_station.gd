class_name CraftingStation extends Control

@export var station_name : String
@onready var title: Label = $Title

enum STATION_TYPE {COOKING, CRAFTING}
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


@onready var description: RichTextLabel = $DetailsPanel/Description

@export var state_machine : StateMachine
@export var idle_state : State
@export var crafting_state : State

var is_crafting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = station_name
	InventoryManager.update_grid_container(bank_container,"Bank",false)
	InventoryManager.update_grid_container(inventory_container,"Inventory",false )
	InventoryManager.clear_grid_container(recipes_container)
	InventoryManager.clear_grid_container(ingredients_container)
	
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
	populate_recipes_list(1)

func _on_ii_button_up() -> void:
	pass # Replace with function body.

func _on_iii_button_up() -> void:
	pass # Replace with function body.

func _on_iv_button_up() -> void:
	pass # Replace with function body.

func _on_exit_button_up() -> void:
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
	can_make.text = "Can Make %s" % [InventoryManager.calculate_quantity(recipe)]
	success_rate.text = "Success Rate " + str(int(recipe.success_rate*100)) + "%"
	
	InventoryManager.clear_grid_container(ingredients_container)
	
	for ingredient in recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
		
		ingredients_container.add_child(ingredient_menu_item)
