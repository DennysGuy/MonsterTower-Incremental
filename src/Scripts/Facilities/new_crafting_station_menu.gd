class_name NewCraftingStationMenu extends Control

@export var station_name: Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grid_container: GridContainer = $HBoxContainer/PanelContainer/MarginContainer/GridContainer
@onready var nothing_to_craft_label: Label = $HBoxContainer/PanelContainer/MarginContainer/NothingToCraftLabel

@onready var panel_animation_player: AnimationPlayer = $PanelAnimationPlayer
@onready var ingredients_h_box: VBoxContainer = $CraftingStationItemSelectPanel/IngredientsHBox
@onready var recipe_name: Label = $CraftingStationItemSelectPanel/RecipeName
@onready var value: Label = $CraftingStationItemSelectPanel/Value
@onready var can_make: Label = $CraftingStationItemSelectPanel/CanMake
@onready var recipe_description: RichTextLabel = $CraftingStationItemSelectPanel/RecipeDescription

@onready var recipe_icon: TextureRect = $CraftingStationItemSelectPanel/RecipeIcon
@onready var craft_1_button: Button = $CraftingStationItemSelectPanel/HBoxContainer2/Craft1Button
@onready var craft_5_button: Button = $CraftingStationItemSelectPanel/HBoxContainer2/Craft5Button
@onready var craft_all_button: Button = $CraftingStationItemSelectPanel/HBoxContainer2/CraftAllButton

enum STATION_TYPE {SMELTING, COOKING}
@export var station_type : STATION_TYPE
# Called when the node enters the scene tree for the first time.

#TODO: IM PROBABLY GOING TO HAVE TO CHECK IF WE'RE COOKING?
#HOW WILL I HANDLE WHEN CRAFTING IS OCCURING? 
#I'M THINKING THAT THIS MENU CAN CLOSE OUT THEN 
#WE'LL SHOW A SMALLER GRAPHIC LOWER TO THE STATION THAT WILL PLAY
#THERE WILL BE AN 'X' Graphic on the lower graphic - player can clic to end

func _ready() -> void:
	CookingManager.populate_description_panel.connect(populate_description_panel)
	if station_type == STATION_TYPE.SMELTING:
		station_name.text = "Refinery"
		populate_craftable_items_list(CookingManager.smelting_recipes)
	elif station_type == STATION_TYPE.COOKING:
		station_name.text = "Cooking Range"
		populate_craftable_items_list(CookingManager.cooking_recipes)
		
	animation_player.play("Spawn In")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_as_cooking_range() -> void:
	station_type = STATION_TYPE.COOKING

func set_as_refinery() -> void:
	station_type = STATION_TYPE.SMELTING

func play_spawn_out() -> void:
	panel_animation_player.play("Phase Out")
	animation_player.play("Spawn Out")

func populate_craftable_items_list(recipe_list : Dictionary) -> void:
	InventoryManager.clear_grid_container(grid_container)
	for tier in recipe_list.keys():
		for recipe in recipe_list[tier]:
			var quantity : int = InventoryManager.calculate_quantity(recipe)
			if quantity >= 1:
				var menu_item : CraftingStationMenuItem = preload("uid://ct3y40uip6cqs").instantiate()
				menu_item.stored_item_recipe = recipe
				grid_container.add_child(menu_item)
	
	if grid_container.get_children().is_empty():
		nothing_to_craft_label.show()

func populate_description_panel(store_recipe : CraftingRecipe) -> void:
	recipe_icon.texture = store_recipe.menu_icon
	recipe_name.text = store_recipe.recipe_name
	value.text = "Market Value: %s" % store_recipe.output_item.sell_value
	var quantity : int = InventoryManager.calculate_quantity(store_recipe)
	can_make.text = "Can Make: %s" % quantity
	recipe_description.text = store_recipe.description
	clear_ingredients_list()
	for ingredient in store_recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
		
		ingredients_h_box.add_child(ingredient_menu_item)
	
	if quantity > 1:
		craft_all_button.show()
	if quantity >= 5:
		craft_5_button.show()
	
	panel_animation_player.play("Phase In")

func clear_ingredients_list() -> void:
	for child in ingredients_h_box.get_children():
		child.queue_free()
