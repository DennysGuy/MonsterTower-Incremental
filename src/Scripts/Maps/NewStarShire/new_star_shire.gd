class_name NewStarShireMap extends Map

@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport
@onready var guide_log: Label = $GuideLog
@onready var control: Control = $CanvasLayer/Control
@onready var enter_market_label: Label = $EnterMarketLabel
@onready var access_crafting_station: Label = $AccessCraftingStation
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var dojo_position: Node2D = $DojoPosition


var player_in_tower_range : bool = false
var player_in_market_range : bool = false
var player_in_cooking_range : bool = false
var player_in_smelting_range : bool = false
var player_in_crafting_range : bool = false
var player_in_dojo_range : bool = false
var player_in_upgrade_station_range : bool = false

@onready var access_smelting_station: Label = $AccessSmeltingStation
@onready var access_sword_crafting_station: Label = $AccessSwordCraftingStation

@onready var cooking_range_position: Node2D = $CookingRangePosition
@onready var refinery_position: Node2D = $RefineryPosition

@onready var smithing_station: SmithingStation = $SmithingStation
@onready var sword_crafting_station_position: Node2D = $SwordCraftingStationPosition

@onready var temp_cooking_range: CookingRangeGraphic = $TempCookingRange
@onready var temp_smelting_station: SmeltingStationGraphic = $TempSmeltingStation
@onready var dojo_access_notification: Label = $Dojo/DojoAccessNotification
@onready var ap_notice: TextureRect = $Dojo/APNotice

@onready var cooking_station: NewCraftingStation = $CookingStation
@onready var refinery: NewCraftingStation = $Refinery

@onready var enter_upgrade_station_notice: Label = $EnterUpgradeStationNotice

@onready var gem_stone_station: Sprite2D = $GemStoneStation

const CLASS_UP_FANFARE = preload("uid://cw28u06grrwni")

const CRAFT_SWORD = preload("uid://4c6l1w0kpar3")
const UNLOCK_SHOP = preload("uid://cveiqvxm5r0yw")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	SignalBus.issue_can_craft_sword_scene.connect(new_sword_unlock_notice)
	SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)
	SignalBus.spawn_class_selection_menu.connect(spawn_dojo_menu)
	SignalBus.spawn_tower_map.connect(spawn_tower_entrance_map)
	SignalBus.play_warrior_unlock_animation.connect(warrior_class_unlocked_notice)
	TechTreeManager.unlock_station.connect(unlock_station)
	SignalBus.spawn_warrior_tech_tree.connect(warrior_class_unlocked_notice)
	#SignalBus.show_ap_notice.connect(show_ap_notice)


	TechTreeManager.update_currency_label.emit()
	InventoryManager.show_bank_button.emit()
	#CookingManager.can_craft_bar.emit()
	hud.animation_player.play("CloseIn")
	
	hud.currency_label.show()
	
	if PlayerStats.player_stats["Equipped Sword"] < PlayerStats.MAX_SWORD_COUNT-1 and PlayerStats.can_craft_next_sword():
		SignalBus.show_can_craft_sword.emit()
		#await get_tree().create_timer(1.0).timeout
		#new_sword_unlock_notice()
	else:
		SignalBus.hide_can_craft_sword.emit()
	print("BELCHUNY")
	#show_ap_notice()
	hud.open_tower_map_button.show()

	await get_tree().process_frame
	SignalBus.update_player_health.emit(player.health)
	PlayerStats.player_stats["Current MP"] = PlayerStats.player_stats["Max MP"] + PlayerStats.get_current_sword().max_mp_bonus + PlayerStats.get_total_gem_bonus("Max MP Bonus")
	SignalBus.update_player_mp.emit()
	SaveManager.save_player_stats()
	if PlayerStats.player_stats["Level"] == 2 and PlayerStats.player_stats["Ability Points"] == 1:
		ability_station_notice()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("interact") and player_in_tower_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Hunter License"]:

		spawn_tower_entrance_map()

	if Input.is_action_just_pressed("interact") and player_in_market_range and GameManager.player_can_move:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_grand_market()
		
	if Input.is_action_just_pressed("interact") and player_in_cooking_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Cooking Station"]:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_cooking_menu()
	
	if Input.is_action_just_pressed("interact") and player_in_smelting_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Refinery Station"]:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_smelting_menu()
	
	if Input.is_action_just_pressed("interact") and player_in_crafting_range and GameManager.player_can_move:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_crafting_menu()

	if Input.is_action_just_pressed("interact") and player_in_dojo_range:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
	
		match PlayerStats.player_stats["Class"]:
			"Junior Hunter":
				spawn_beginner_tree()
			"Tyro":
				spawn_warrior_tech_tree()
		#spawn_dojo_menu()
		
	if Input.is_action_just_pressed("interact") and player_in_upgrade_station_range and PlayerStats.facilities_unlocked["Gem Stone Station"]:
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_upgrade_menu()

func add_tech_tree_to_scene() -> void:
	canvas_layer.show()
	player.velocity = Vector2.ZERO
	var tech_tree : TechTree = preload("uid://b7n3fwd3y85wp").instantiate()
	sub_viewport.add_child(tech_tree)

func hide_tech_tree_canvas_layer() -> void:
	canvas_layer.hide()

func set_guide_log(show_log : bool) -> void:
	if show_log:
		guide_log.show()
	else:
		guide_log.hide()
	
	if PlayerStats.facilities_unlocked["Hunter License"]:
		guide_log.text = "Press E to enter the tower!"
	else:
		guide_log.text = "You need a Tower pass before you can Enter..."

func _on_tower_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = true
		set_guide_log(true)

func show_ap_notice() -> void:
	if PlayerStats.player_stats["Ability Points"] >= 1 and PlayerStats.player_stats["Class"] == "Junior Hunter":
		SignalBus.show_class_notice.emit()
		ap_notice.show()
	else:
		SignalBus.show_class_notice.emit()
		ap_notice.hide()

func _on_tower_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = false
		set_guide_log(false)

func go_to_test_floor() -> void:
	GameManager.spawn_location = 0
	hud.animation_player.play("CloseOut")
	GameManager.player_can_move = true
	GameManager.resupply_character = true
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.move_inventory_to_bank()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/Tower/TowerFloors/Biome1/Floor1-1.tscn")

func spawn_tower_entrance_map() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	GameManager.player_can_move = false
	player.velocity = Vector2.ZERO
	canvas_layer.show()
	var tower_entrance_map : TowerEntranceMap = preload("uid://bgurt44iah13x").instantiate()
	control.add_child(tower_entrance_map)

func spawn_grand_market() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var market : GrandMarketMenu = preload("uid://cfuw5h0apwpq").instantiate()
	control.add_child(market)

func spawn_cooking_menu() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var cooking_range : CookingMenu = preload("uid://cotvjq5dygv7p").instantiate()
	control.add_child(cooking_range)

func spawn_smelting_menu() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var smelting_station : SmeltingMenu = preload("uid://dtf6m65mtihb8").instantiate()
	control.add_child(smelting_station)

func spawn_crafting_menu() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var sword_crafting_station : CraftingStationMenu = preload("uid://cc1xppx3tkq4f").instantiate()
	control.add_child(sword_crafting_station)

func spawn_upgrade_menu() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var gem_stone_station : GemStoneStation = preload("uid://v4skqw8t11ip").instantiate()
	control.add_child(gem_stone_station)

func spawn_beginner_tree() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var beginner_ability_tree : BeginnerTechTree = preload("uid://y6ru08whvroa").instantiate()
	sub_viewport.add_child(beginner_ability_tree)


func spawn_warrior_tech_tree() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	GameManager.can_pause_game = false
	canvas_layer.show()
	var warrior_tech_tree : NewAbilityUpgradeMenu = preload("uid://d0r1bngbqs2ch").instantiate()
	sub_viewport.add_child(warrior_tech_tree)


func spawn_dojo_menu() -> void:
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	canvas_layer.show()
	var class_selection_menu : ClassSelectionMenu = preload("uid://b404uvbhnmjxd").instantiate()
	control.add_child(class_selection_menu)
	
func _on_grand_market_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = true
		enter_market_label.show()

func _on_grand_market_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = false
		enter_market_label.hide()

func _on_cooking_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_cooking_range = true
		if !PlayerStats.facilities_unlocked["Cooking Station"]:
			access_crafting_station.text = "Cooking Range under construction!"
		else:
			access_crafting_station.text = "Press 'E' to access Cooking Range"
		access_crafting_station.show()

func _on_cooking_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_cooking_range = false
		access_crafting_station.hide()

func _on_smelting_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_smelting_range = true
		if !PlayerStats.facilities_unlocked["Refinery Station"]:
			access_smelting_station.text = "Refinery under construction!"
		else:
			access_smelting_station.text = "Press 'E' to access Refinery"
		access_smelting_station.show()

func _on_smelting_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_smelting_range = false
		access_smelting_station.hide()

func _on_crafting_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_crafting_range = true
		access_sword_crafting_station.show()
	
func _on_crafting_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_crafting_range = false
		access_sword_crafting_station.hide()


func unlock_cooking_station() -> void:
	camera.player = null
	player.send_to_idle_state()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	sfx_player.play_sfx(UNLOCK_SHOP)
	camera.position = cooking_range_position.position
	await get_tree().create_timer(1.0).timeout
	hud.animation_player.play("Flash")
	await get_tree().create_timer(0.5).timeout
	cooking_station.unlock_cooking_station()
	SignalBus.issue_big_notification.emit("Cook exotic dishes and sell for big cash!")
	await get_tree().create_timer(2.0).timeout
	SignalBus.issue_big_notification.emit("Cooking Resources Drop From Monsters!")
	await get_tree().create_timer(3.0).timeout
	SignalBus.hide_big_notification.emit()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	PlayerStats.show_cooking_station_unlock_animation = false
	
func unlock_refinery_station() -> void:
	camera.player = null
	player.send_to_idle_state()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	sfx_player.play_sfx(UNLOCK_SHOP)
	camera.position = refinery_position.position
	await get_tree().create_timer(1.0).timeout
	hud.animation_player.play("Flash")
	await get_tree().create_timer(0.5).timeout
	refinery.unlock_refinery()
	SignalBus.issue_big_notification.emit("Refine Raw Resources into Craftable Material!")
	await get_tree().create_timer(2.0).timeout
	SignalBus.issue_big_notification.emit("You have unlocked the stone pickaxe.")
	await get_tree().create_timer(3.0).timeout
	SignalBus.issue_big_notification.emit("Tin and Copper ore can now be mined in the Tower!")
	await get_tree().create_timer(3.5).timeout
	SignalBus.hide_big_notification.emit()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	PlayerStats.show_refinery_station_unlock_animation = false

func unlock_station() -> void:
	GameManager.player_can_move = false
	if PlayerStats.show_cooking_station_unlock_animation:
		await unlock_cooking_station()
	
	if PlayerStats.show_refinery_station_unlock_animation:
		await unlock_refinery_station()
	
	if PlayerStats.show_gem_station_unlock_animation:
		await gem_station_unlock_notice()
	
	GameManager.player_can_move = true

func new_sword_unlock_notice() -> void:
	GameManager.player_can_move = false
	camera.player = null
	player.send_to_idle_state()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	smithing_station.notify_can_craft()
	camera.position = sword_crafting_station_position.position
	SignalBus.issue_big_notification.emit("A New Sword Can Be Unlocked!")
	await get_tree().create_timer(3.5).timeout
	SignalBus.hide_big_notification.emit()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	GameManager.player_can_move = true

func warrior_class_unlocked_notice() -> void:
	GameManager.player_can_move = false
	player.send_to_idle_state()
	MusicPlayer.stop_player()
	sfx_player.play_sfx(UNLOCK_SHOP)
	hud.animation_player.play("Flash")
	play_sfx(CLASS_UP_FANFARE)
	SignalBus.flash_screen.emit()
	await get_tree().create_timer(1.5).timeout
	spawn_warrior_tech_tree()
	SignalBus.hide_big_notification.emit()
	GameManager.player_can_move = true
	await get_tree().create_timer(8.5).timeout
	MusicPlayer.play_song(map_theme_song)

func gem_station_unlock_notice() -> void:
	camera.player = null
	player.send_to_idle_state()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	smithing_station.notify_can_craft()
	camera.position = sword_crafting_station_position.position
	
	SignalBus.show_gem_station_arrow.emit()
	SignalBus.issue_big_notification.emit("Your weapon can now be enhanced with Gem Stones.")
	await get_tree().create_timer(2.0).timeout
	SignalBus.issue_big_notification.emit("Access the Gem Stone station to mount gems onto your weapon!")
	await get_tree().create_timer(3.5).timeout
	SignalBus.hide_big_notification.emit()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	PlayerStats.show_gem_station_unlock_animation = false

func ability_station_notice() -> void:
	camera.player = null
	player.send_to_idle_state()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = dojo_position.position
	
	SignalBus.issue_big_notification.emit("Spend AP acquired from leveling up\n At the Class Advancement Center!")
	await get_tree().create_timer(3.0).timeout
	SignalBus.hide_big_notification.emit()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	PlayerStats.show_gem_station_unlock_animation = false

func _on_dojo_area_body_entered(body: Node2D) -> void:
	if body is Player:
		dojo_access_notification.text = "Press E to Access Dojo!"		
		player_in_dojo_range = true
		dojo_access_notification.show()

func _on_dojo_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_dojo_range = false
		dojo_access_notification.hide()

func _on_gem_stone_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_upgrade_station_range = true
		if PlayerStats.facilities_unlocked["Gem Stone Station"]:
			enter_upgrade_station_notice.text = "Press 'E' to Access\nGem Stone Station"
		else:
			enter_upgrade_station_notice.text = "Unlock Gem Stone\nStation Node to access!"
		enter_upgrade_station_notice.show()

func _on_gem_stone_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_upgrade_station_range = false
		enter_upgrade_station_notice.hide()
