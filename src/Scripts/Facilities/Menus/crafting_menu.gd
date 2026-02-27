class_name CraftingStationMenu extends Control

@onready var sword_name: Label = $SwordName
@onready var sword_description: RichTextLabel = $SwordDescription
@onready var sword_stats: RichTextLabel = $SwordStats

@onready var ingredients_list: GridContainer = $IngredientsList

@onready var sword_graphic: TextureRect = $SwordGraphic

@onready var inventory_container: GridContainer = $InventoryContainer
@onready var bank_container: GridContainer = $BankContainer
@onready var bank_notice: Label = $BankNotice
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sfx_player: SFXPlayer = $SfxPlayer
const CRAFT_SWORD = preload("uid://4c6l1w0kpar3")

var sword : Sword
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory_containers()
	update_sword()
	GameManager.can_pause_game = false
	#we need to go into player stats, grab equipped sword index and find the recipe and the actual sword resource

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		exit_menu()
		
func _on_button_button_up() -> void:
	sfx_player.play_sfx(CRAFT_SWORD)
	await get_tree().create_timer(1.5).timeout
	animation_player.play("CraftingFlash")

func upgrade_sword() -> void:
	InventoryManager.remove_resources_from_inventory(sword.recipe.recipe_list)
	var next_sword_index = PlayerStats.player_stats["Equipped Sword"]+1
	if next_sword_index < PlayerStats.MAX_SWORD_COUNT:
		PlayerStats.player_stats["Equipped Sword"] += 1
		update_sword()
		SaveManager.save_inventories()
		update_inventory_containers()
		SignalBus.update_sword_texture.emit("Idle")
		
func update_inventory_containers() -> void:
	InventoryManager.update_grid_container(inventory_container, "Inventory",false)
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank",false)
	else:
		bank_notice.show()

func update_sword() -> void: #run this function when we upgrade the sword.
	var next_sword_index = PlayerStats.player_stats["Equipped Sword"]+1
	SaveManager.save_player_stats()
	if next_sword_index < PlayerStats.MAX_SWORD_COUNT:
		var sword_index = int(next_sword_index)
		sword = PlayerStats.get_sword(sword_index)
		sword_name.text = sword.sword_name
		sword_stats.text = sword.get_stats_description()
		sword_description.text = sword.recipe.description
		
		InventoryManager.clear_grid_container(ingredients_list)
		for ingredient in sword.recipe.recipe_list:
			var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
			for key in ingredient.keys():

				ingredient_menu_item.ingredient_icon.texture = key.shop_icon
				ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
			
			ingredients_list.add_child(ingredient_menu_item)

		var can_craft : bool = InventoryManager.calculate_quantity(sword.recipe)
		
		if can_craft:
			button.disabled = false
			sword_graphic.texture = sword.graphic
		else:
			button.disabled = true
			sword_graphic.texture = sword.mold_graphic
			

		SignalBus.update_resource_needed_panel.emit()

func _on_close_button_up() -> void:
	exit_menu()

func exit_menu() -> void:
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	
	SignalBus.check_can_sword_craft.emit()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()
