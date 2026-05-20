class_name RecipeBook extends Control

@onready var recipe_grid_container: GridContainer = $ScrollContainer/RecipeGridContainer
@onready var dish_name: Label = $DescriptionPanel/DishName
@onready var tier: Label = $DescriptionPanel/Tier
@onready var graphic: TextureRect = $DescriptionPanel/Graphic
@onready var description: RichTextLabel = $DescriptionPanel/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.load_recipe_unlocks_status()
	CodexManager.populate_recipe_description_panel.connect(populate_description_panel)
	create_dish_recipe_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_recipe_list(recipe_list : Array, unlocked_list : Array) -> void:
	InventoryManager.clear_grid_container(recipe_grid_container)
	
	for i in range(0,recipe_list.size()):
		var list_item : CraftingRecipeListItem = preload("uid://bc10kb6pbi3ro").instantiate()
		list_item.crafting_recipe = recipe_list[i]
		
		if not unlocked_list[i]["Unlocked 1"]:
			list_item.text = "- ???????????" 
		else:
			list_item.text = "- %s" % recipe_list[i].recipe_name
			list_item.unlocked = true
		
		recipe_grid_container.add_child(list_item)
		await get_tree().create_timer(0.05).timeout

func populate_description_panel(recipe : CraftingRecipe) -> void:
	dish_name.text = recipe.recipe_name
	graphic.texture = recipe.output_item.shop_icon
	description.text = recipe.description

func create_dish_recipe_list() -> void:
	create_recipe_list(CodexManager.dish_recipes, CodexManager.dish_recipe_unlocks)

func create_bar_recipe_list() -> void:
	create_recipe_list(CodexManager.bar_recipes, CodexManager.bar_recipe_unlocks)

func _on_dish_recipes_button_up() -> void:
	create_dish_recipe_list()

func _on_bar_recipes_button_up() -> void:
	create_bar_recipe_list()
