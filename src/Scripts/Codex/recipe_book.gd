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
@onready var related_enemies_container: GridContainer = $DescriptionPanel/RelatedEnemiesContainer
@onready var related_enemies_title: Label = $DescriptionPanel/RelatedEnemiesTitle


@onready var monster_icons : Dictionary[String, Texture2D] = {
	"Willow Shrub": preload("uid://c754jleh4a7km"),
	"Corrupted Mushie": preload("uid://doykjgx3b67qt"),
	"Corrupted Mushie LVL2": preload("uid://cudxjr3yw3imr"),
	"Batclopse": preload("uid://ccr111d7lh2cy"),
	"Batclopse LVL2": preload("uid://fxchlb1rbpw7"),
	"Beetle Knight": preload("uid://bwlqhfw83akup"),
	"Beetle Knight LVL2": preload("uid://csia73ycbfkej"),
	"Serpant Mimic": preload("uid://cmd1xfjwqwc26"),
	"Serpant Mimic LVL2": preload("uid://bmtdvubgm23v8"),
	"Goblin Thief": preload("uid://m3x60greqbfs"),
	"Orc Warlord": preload("uid://dai0ybp7jtl2t"),
	"Moss Golem": preload("uid://dxk40dnppe36a")
}



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
	populate_recipe_container(recipe)
	populate_related_grid(recipe)

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
			
func populate_recipe_container(recipe : CraftingRecipe) -> void:
	InventoryManager.clear_grid_container(recipe_container)

	recipe_title.text = "Recipe"
	for ingredient in recipe.recipe_list:
		var list_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for item in ingredient.keys():
			list_item.ingredient_icon.texture = item.shop_icon
			var currently_held : int = InventoryManager.get_quantity(item,item.get_inventory_name())
			list_item.quantity.text = "%s/%s" % [currently_held,ingredient[item]]
			recipe_container.add_child(list_item)

func populate_related_grid(recipe : CraftingRecipe) -> void:
	InventoryManager.clear_grid_container(related_enemies_container)
	if !recipe.related_enemies.is_empty():
		related_enemies_title.show()
		for monster_name in recipe.related_enemies:
			var texture_rect : PreviewIconGraphic = preload("uid://c53idabyvvlhs").instantiate()
			texture_rect.texture = monster_icons[monster_name]
			related_enemies_container.add_child(texture_rect)
	else:
		related_enemies_title.hide()
		

func _on_dish_recipes_button_up() -> void:
	create_dish_recipe_list()

func _on_bar_recipes_button_up() -> void:
	create_bar_recipe_list()
