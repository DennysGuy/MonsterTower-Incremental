class_name RecipeBook extends Control

@onready var recipe_grid_container: GridContainer = $ScrollContainer/RecipeGridContainer
@onready var dish_name: Label = $DescriptionPanel/DishName
@onready var tier: Label = $DescriptionPanel/Tier
@onready var graphic: TextureRect = $DescriptionPanel/Graphic
@onready var description: RichTextLabel = $DescriptionPanel/Description
@onready var nodes_container: GridContainer = $DescriptionPanel/NodesContainer
@onready var recipe_container: GridContainer = $DescriptionPanel/RecipeContainer
@onready var sell_price: Label = $DescriptionPanel/SellPrice
@onready var can_make: Label = $DescriptionPanel/CanMake
@onready var recipe_title: Label = $DescriptionPanel/RecipeTitle


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
	sell_price.text = "Market Price: %s" % recipe.output_item.sell_value
	can_make.text = "Can Make: %s" % InventoryManager.calculate_quantity(recipe)
	populate_nodes_container(recipe)
	populate_recipe_container(recipe, CodexManager.dish_recipe_unlocks)

func create_dish_recipe_list() -> void:
	create_recipe_list(CodexManager.dish_recipes, CodexManager.dish_recipe_unlocks)

func create_bar_recipe_list() -> void:
	create_recipe_list(CodexManager.bar_recipes, CodexManager.bar_recipe_unlocks)

func populate_nodes_container(recipe : CraftingRecipe) -> void:
	InventoryManager.clear_grid_container(nodes_container)
	for node_name in recipe.related_nodes:
		var list_item : NodeTitleListItem = preload("uid://coa3yxyswf6aj").instantiate()
		if TechTreeManager.get_tech_node_status(node_name):
			list_item.text = "- %s" % node_name
		else:
			list_item.text = "- ???????"
		nodes_container.add_child(list_item)
			
func populate_recipe_container(recipe : CraftingRecipe, unlocks_list : Array) -> void:
	InventoryManager.clear_grid_container(recipe_container)
	if not unlocks_list[recipe.index]["Unlocked 2"]:
		recipe_title.text = "Recipe (Craft %s)" % int(CodexManager.RECIPE_THRESH_HOLD_2-unlocks_list[recipe.index]["Count"])
	else:
		recipe_title.text = "Recipe"
	for ingredient in recipe.recipe_list:
		var list_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for item in ingredient.keys():
			if unlocks_list[recipe.index]["Unlocked 2"]:
				list_item.ingredient_icon.texture = item.shop_icon
			else:
				list_item.ingredient_icon.texture =  preload("uid://cbcw7ua8sro78")
			
			list_item.quantity.text = "x%s" % ingredient[item]
			recipe_container.add_child(list_item)

func _on_dish_recipes_button_up() -> void:
	create_dish_recipe_list()

func _on_bar_recipes_button_up() -> void:
	create_bar_recipe_list()
