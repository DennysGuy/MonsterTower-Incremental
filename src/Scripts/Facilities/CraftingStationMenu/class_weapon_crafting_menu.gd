class_name ClassWeaponCraftingMenu extends Control


#Inventory Side
@onready var bag_bg: TextureRect = $Inventory/BagBG
@onready var inventory_title: Label = $Inventory/InventoryTitle

@onready var inventory_container: GridContainer = $Inventory/InventoryContainer
@onready var bank_container: GridContainer = $Inventory/BankContainer
@onready var bank_account_locked_notice: Label = $Inventory/BankAccountLockedNotice

#Description Side
@onready var weapon_name: Label = $DescriptionPanel/WeaponName
@onready var description_label: RichTextLabel = $DescriptionPanel/DescriptionPanel/DescriptionLabel
@onready var ingredients_container: GridContainer = $DescriptionPanel/IngredientsContainer
@onready var stat_bonuses_label: RichTextLabel = $DescriptionPanel/StatBonusesLabel
@onready var description_panel: TextureRect = $DescriptionPanel

#Weapon Menu Side
@onready var warrior_weapon_container: GridContainer = $ForeGround/WarriorWeaponContainer
@onready var weapon_mold_graphic: TextureRect = $ForeGround/WeaponMoldGraphic
@onready var action_button: Button = $ForeGround/ActionButton

@export var stored_weapon : Sword

const GEAR_STATION_DROPS_BAG_BG = preload("uid://dqrwhfhixd1io")
const GEAR_STATION_USE_BAG_BG = preload("uid://b5o4unayrrfi")
const NEW_WEAPON_CRAFTING_STATION_UPDATE_SCENE = preload("uid://olt7ljpn0wpg")

var selected_bag : String = "Drops"

var description_panel_showing : bool = false
@onready var show_details_button: Button = $ForeGround/ShowDetailsButton

const JOB_ACCEPT_JINGLE = preload("uid://dinxl1rs2y55v")

enum STATE {IDLE, CAN_CRAFT, CAN_TRACK, CAN_EQUIP}
var state : STATE = STATE.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.populate_weapon_description_panel.connect(select_weapon)
	update_inventory_containers()
	if GameManager.first_class_just_unlocked:
		Dialogic.start(NEW_WEAPON_CRAFTING_STATION_UPDATE_SCENE)
		GameManager.first_class_just_unlocked = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		exit_menu()

func _on_action_button_button_up() -> void:
	match state:
		STATE.CAN_CRAFT:
			craft_sequence()
		STATE.CAN_TRACK:
			track_weapon_recipe()
		STATE.CAN_EQUIP:
			equip_weapon()

func craft_sequence() -> void:
	SaveManager.save_weapon_unlocked_status(stored_weapon.index, true)
	SaveManager.save_weapon_tracked_status(stored_weapon.index, false)
	InventoryManager.remove_resources_from_inventory(stored_weapon.recipe.recipe_list)
	PlayerStats.player_stats["Tracked Weapon"] = -1
	SaveManager.save_player_stats()
	
	stored_weapon.is_tracked = SaveManager.get_weapon_tracked_status(stored_weapon.index)
	stored_weapon.unlocked = SaveManager.get_weapon_unlocked_status(stored_weapon.index)
	SignalBus.update_held_weapon.emit(stored_weapon)
	SignalBus.disable_tracked_icon.emit(stored_weapon.index)
	
	equip_weapon()
	spawn_crafting_sequence()
	select_weapon(stored_weapon)
	
func equip_weapon() -> void:
	PlayerStats.player_stats["Equipped Sword"] = stored_weapon.index
	SaveManager.save_player_stats()
	#Play Sword Equip Animation Here
	SignalBus.update_sword_texture.emit("Idle")
	spawn_equipped_sequence()

func track_weapon_recipe() -> void:
	if PlayerStats.player_stats["Tracked Weapon"] > -1:
		var previous_weapon : Sword = PlayerStats.get_sword(PlayerStats.player_stats["Tracked Weapon"])
		SaveManager.save_weapon_tracked_status(previous_weapon.index, false)
		SignalBus.disable_tracked_icon.emit(previous_weapon.index)
	
	PlayerStats.set_tracked_weapon_index(stored_weapon.index) 
	SaveManager.save_player_stats()
	SaveManager.save_weapon_tracked_status(stored_weapon.index, true)
	SignalBus.update_resource_needed_panel.emit()
	SignalBus.show_tracked_icon.emit(stored_weapon.index)
	select_weapon(stored_weapon)
	play_sfx(JOB_ACCEPT_JINGLE)

func exit_menu() -> void:
	CutsceneManager.enable_player_functionality()
	
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

func update_inventory_containers() -> void:
	show_inventory(selected_bag)
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank",false)
	else:
		bank_account_locked_notice.show()

func show_inventory(bag_name : String) -> void:
	match bag_name:
		"Drops":
			bag_bg.texture = GEAR_STATION_DROPS_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Inventory", false)
			selected_bag = "Drops"
		"Use":
			bag_bg.texture = GEAR_STATION_USE_BAG_BG
			InventoryManager.update_grid_container(inventory_container, "Use", false)
			selected_bag = "Use"
			
	selected_bag = bag_name
	inventory_title.text = bag_name

func select_weapon(weapon : Sword) -> void:
	stored_weapon = weapon
	weapon_name.text = stored_weapon.sword_name
	if weapon.unlocked:
		weapon_mold_graphic.texture = weapon.graphic
	else:
		weapon_mold_graphic.texture = weapon.mold_graphic
		
	description_label.text = stored_weapon.description
	stat_bonuses_label.text = stored_weapon.get_stats_description()
	populate_ingredients_list(stored_weapon)
	update_action_button(weapon)
	if !description_panel_showing:
		show_description_panel()

func show_description_panel() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(description_panel, "position",Vector2(176,64),0.1)
	description_panel_showing = true
	show_details_button.text = "Hide Details"

func hide_description_panel() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(description_panel, "position",Vector2(640,64),0.1)
	description_panel_showing = false
	show_details_button.text = "Show Details"

func populate_ingredients_list(weapon : Sword) -> void:
	InventoryManager.clear_grid_container(ingredients_container)
	for ingredient in weapon.recipe.recipe_list:
		var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
		for key in ingredient.keys():

			ingredient_menu_item.ingredient_icon.texture = key.shop_icon
			ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
			
		ingredients_container.add_child(ingredient_menu_item)

func _on_show_details_button_button_up() -> void:
	if !description_panel_showing:
		show_description_panel()
	else:
		hide_description_panel()

func _on_show_details_button_2_button_up() -> void:
	exit_menu()

func update_action_button(weapon : Sword) -> void:
	var can_craft : int = InventoryManager.calculate_quantity(stored_weapon.recipe)
	state = STATE.IDLE

	if stored_weapon.unlocked:
		if PlayerStats.get_current_sword() != stored_weapon:
			action_button.text = "Equip!"
			action_button.disabled = false
			state = STATE.CAN_EQUIP
		else:
			action_button.text = "Currently Equipped"
			action_button.disabled = true
	else:
		if can_craft > 0:
			action_button.disabled = false
			action_button.text = "Craft!"
			state = STATE.CAN_CRAFT
		else:
			if stored_weapon.index != PlayerStats.player_stats["Tracked Weapon"]:
				action_button.text = "Track!"
				action_button.disabled = false
				state = STATE.CAN_TRACK
			else:
				action_button.text = "Tracking..."
				action_button.disabled = true

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func spawn_crafting_sequence() -> void:
	var crafting_animation : CraftingAnimation = preload("uid://2bfb4gmhtb7").instantiate()
	add_child(crafting_animation)
	crafting_animation.play_smithing_sequence()
	

func spawn_equipped_sequence() -> void:
	var equip_animation : CraftingAnimation = preload("uid://2bfb4gmhtb7").instantiate()
	add_child(equip_animation)
	equip_animation.play_equipped_sequence()
