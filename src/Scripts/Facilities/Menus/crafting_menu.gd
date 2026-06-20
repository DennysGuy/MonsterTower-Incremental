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
@onready var bag_bg: TextureRect = $BagBG
@onready var inventory_label: Label = $InventoryLabel

@onready var sfx_player: SFXPlayer = $SfxPlayer
const CRAFT_SWORD = preload("uid://4c6l1w0kpar3")
@onready var recipe: Label = $Recipe

var sword : Sword
@onready var button: Button = $Button

const GEAR_STATION_DROPS_BAG_BG = preload("uid://dqrwhfhixd1io")
const GEAR_STATION_USE_BAG_BG = preload("uid://b5o4unayrrfi")

var selected_bag : String = "Drops"

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
	spawn_crafting_sequence()
	await get_tree().create_timer(4.0).timeout
	upgrade_sword()
	
func upgrade_sword() -> void:
	InventoryManager.remove_resources_from_inventory(sword.recipe.recipe_list)
	QuestManager.check_general_task_for_completion.emit("Upgrade Sword")
	
	PlayerStats.player_stats["Equipped Sword"] = sword.index
	SaveManager.save_player_stats()
	
	var next_sword_index : int = PlayerStats.player_stats["Equipped Sword"]+1
	if next_sword_index < PlayerStats.BEGINNGER_SWORD_COUNT:
		PlayerStats.set_tracked_weapon_index(next_sword_index)
		sword = PlayerStats.get_sword(next_sword_index)
	else:
		PlayerStats.set_tracked_weapon_index(-1)
	
	update_sword()
	update_inventory_containers()
	SignalBus.update_sword_texture.emit("Idle")
	
	SaveManager.save_player_stats()
	SaveManager.save_inventories()	
	
func update_inventory_containers() -> void:
	#InventoryManager.update_grid_container(inventory_container, "Inventory",false)
	show_inventory(selected_bag)
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank",false)
	else:
		bank_notice.show()

func update_sword() -> void: #run this function when we upgrade the sword.
	var tracked_index : int = PlayerStats.player_stats["Tracked Weapon"]
	
	if tracked_index == -1:
		sword = null
		sword_graphic.texture = null
		button.disabled = true
		recipe.text = "More weapons when Combat Class selected!"
		SignalBus.update_resource_needed_panel.emit()
		return
	
	if tracked_index < PlayerStats.BEGINNGER_SWORD_COUNT:
		sword = PlayerStats.get_sword(tracked_index)
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
	CutsceneManager.enable_player_functionality()
	SignalBus.check_can_sword_craft.emit()
	
	SignalBus.update_resource_needed_panel.emit()
	SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.CRAFTING)
	
	PlayerHudSignalBus.hub_menu_exited.emit()
	await get_tree().create_timer(0.3).timeout
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func _on_drops_bag_button_button_up() -> void:
	show_inventory("Drops")

func _on_use_bag_button_button_up() -> void:
	show_inventory("Use")

func show_inventory(bag_name : String) -> void:
	match bag_name:
		"Drops":
			bag_bg.texture = GEAR_STATION_DROPS_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Inventory", false)

		"Use":
			bag_bg.texture = GEAR_STATION_USE_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Use", false)

	selected_bag = bag_name
	inventory_label.text = bag_name

func spawn_crafting_sequence() -> void:
	var crafting_animation : CraftingAnimation = preload("uid://2bfb4gmhtb7").instantiate()
	add_child(crafting_animation)
	crafting_animation.play_smithing_sequence()
	
