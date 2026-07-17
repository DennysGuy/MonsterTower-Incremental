class_name NewCraftingStationMenu extends Control

@export var station_name: Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/GridContainer
@onready var nothing_to_craft_label: Label = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/NothingToCraftLabel

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

@onready var success_rate: Label = $CraftingStationItemSelectPanel/RatePanel/SuccessRate
@onready var failure_rate: Label = $CraftingStationItemSelectPanel/RatePanel/FailureRate

@onready var slider_amount_label: Label = $CraftingStationItemSelectPanel/SliderAmountLabel

@export var station_type : STATION_TYPE
@onready var slider_amount: HSlider = $CraftingStationItemSelectPanel/SliderAmount

@export var station : NewCraftingStation
var stored_recipe : CraftingRecipe
var stored_amount : int = 0
var max_quantity : int = 0
# Called when the node enters the scene tree for the first time.
@onready var star_tier_h_box: HBoxContainer = $CraftingStationItemSelectPanel/StarTierHBox

#TODO: IM PROBABLY GOING TO HAVE TO CHECK IF WE'RE COOKING?
#HOW WILL I HANDLE WHEN CRAFTING IS OCCURING? 
#I'M THINKING THAT THIS MENU CAN CLOSE OUT THEN 
#WE'LL SHOW A SMALLER GRAPHIC LOWER TO THE STATION THAT WILL PLAY
#THERE WILL BE AN 'X' Graphic on the lower graphic - player can clic to end
const CRAFTING_STATION_OPEN = preload("uid://ccqpi3mcw8aww")
const CRAFTING_STATION_OPEN_2 = preload("uid://bjeafrfocbiqe")

func _ready() -> void:
	CookingManager.populate_description_panel.connect(populate_description_panel)
	if station_type == STATION_TYPE.SMELTING:
		station_name.text = "Refinery"
		populate_craftable_items_list(CookingManager.smelting_recipes)
	elif station_type == STATION_TYPE.COOKING:
		station_name.text = "Junk-A-Tron"
		populate_craftable_items_list(CookingManager.cooking_recipes)
	play_sfx(CRAFTING_STATION_OPEN_2)
	animation_player.play("Spawn In")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_as_cooking_range() -> void:
	station_type = STATION_TYPE.COOKING

func set_as_refinery() -> void:
	station_type = STATION_TYPE.SMELTING

func play_spawn_out() -> void:
	play_sfx(CRAFTING_STATION_OPEN_2)
	panel_animation_player.play("Phase Out")
	animation_player.play("Spawn Out")

func populate_craftable_items_list(recipe_list : Dictionary) -> void:
	InventoryManager.clear_grid_container(grid_container)
	nothing_to_craft_label.show()
	for tier in recipe_list.keys():
		for recipe in recipe_list[tier]:
			var quantity : int = InventoryManager.calculate_quantity(recipe)
			if quantity >= 1:
				var menu_item : CraftingStationMenuItem = preload("uid://ct3y40uip6cqs").instantiate()
				menu_item.stored_item_recipe = recipe
				grid_container.add_child(menu_item)
				nothing_to_craft_label.hide()

func populate_description_panel(store_recipe : CraftingRecipe) -> void:
	stored_recipe = store_recipe
	populate_tier_bar(stored_recipe.recipe_tier)
	recipe_icon.texture = store_recipe.menu_icon
	recipe_name.text = store_recipe.recipe_name
	value.text = "Market Value: %s" % store_recipe.output_item.sell_value
	max_quantity = InventoryManager.calculate_quantity(store_recipe)
	can_make.text = "Can Make: %s" % max_quantity
	recipe_description.text = store_recipe.description
	clear_ingredients_list()
	for ingredient in store_recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://6t8pqnxisosy").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
		
		ingredients_h_box.add_child(ingredient_menu_item)
	
	stored_amount = 1
	
	slider_amount_label.text = "%s/%s" % [stored_amount,max_quantity]
	slider_amount.value = stored_amount
	slider_amount.max_value = max_quantity
	if max_quantity > 1:
		craft_all_button.show()
	if max_quantity >= 5:
		craft_5_button.show()
	
	panel_animation_player.play("Phase In")
	success_rate.text = "Success: %s" % int(stored_recipe.success_rate * 100) + "%"
	failure_rate.text = "Fail: %s" % int(100 - (stored_recipe.success_rate * 100)) + "%"

func clear_ingredients_list() -> void:
	for child in ingredients_h_box.get_children():
		child.queue_free()

func _on_craft_1_button_button_up() -> void:
	craft_1_button.disabled = true
	craft_5_button.disabled = true
	craft_all_button.disabled = true
	station.start_crafting(stored_recipe, stored_amount)
	play_spawn_out()

func _on_craft_5_button_button_up() -> void:
	stored_amount = 5
	station.start_crafting(stored_recipe, stored_amount)
	play_spawn_out()

func _on_craft_all_button_button_up() -> void:
	var calculated_quantity : int = InventoryManager.calculate_quantity(stored_recipe)
	station.start_crafting(stored_recipe, calculated_quantity)
	play_spawn_out()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func populate_tier_bar(num : int) -> void:
	clear_tier_bar()
	for i in range(num):
		var star : TextureRect = preload("uid://cjp8ifo5avha3").instantiate()
		star_tier_h_box.add_child(star)

func clear_tier_bar() -> void:
	if star_tier_h_box.get_children().is_empty():
		return
	
	for child in star_tier_h_box.get_children():
		child.queue_free()

func _on_slider_amount_value_changed(value: float) -> void:
	slider_amount_label.text = "%s/%s" % [int(value), max_quantity]
	stored_amount = int(value)
