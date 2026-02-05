class_name NewStarShireMap extends Map

@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport
@onready var guide_log: Label = $GuideLog
@onready var control: Control = $CanvasLayer/Control
@onready var enter_market_label: Label = $EnterMarketLabel
@onready var access_crafting_station: Label = $AccessCraftingStation

var player_in_tower_range : bool = false
var player_in_market_range : bool = false
var player_in_cooking_range : bool = false
var player_in_smelting_range : bool = false
var player_in_crafting_range : bool = false
var player_in_dojo_range : bool = false

@onready var access_smelting_station: Label = $AccessSmeltingStation
@onready var access_sword_crafting_station: Label = $AccessSwordCraftingStation

@onready var cooking_range_position: Node2D = $CookingRangePosition
@onready var refinery_position: Node2D = $RefineryPosition

@onready var smithing_station: SmithingStation = $SmithingStation
@onready var sword_crafting_station_position: Node2D = $SwordCraftingStationPosition

@onready var temp_cooking_range: CookingRangeGraphic = $TempCookingRange
@onready var temp_smelting_station: SmeltingStationGraphic = $TempSmeltingStation
@onready var dojo_access_notification: Label = $Dojo/DojoAccessNotification

const CRAFT_SWORD = preload("uid://4c6l1w0kpar3")
const UNLOCK_SHOP = preload("uid://cveiqvxm5r0yw")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	SignalBus.issue_can_craft_sword_scene.connect(new_sword_unlock_notice)
	TechTreeManager.unlock_station.connect(unlock_station)

	CookingManager.can_craft_bar.emit()
	hud.animation_player.play("CloseIn")

	if PlayerStats.player_stats["Equipped Sword"] < PlayerStats.MAX_SWORD_COUNT-1 and PlayerStats.can_craft_next_sword():
		SignalBus.show_can_craft_sword.emit()
		await get_tree().create_timer(1.0).timeout
		new_sword_unlock_notice()
	else:
		SignalBus.hide_can_craft_sword.emit()
	
	await get_tree().process_frame
	SignalBus.update_player_health.emit(player.health)
	SaveManager.save_player_stats()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_tower_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Hunter License"]:
		GameManager.player_can_move = false
		if PlayerStats.check_points_unlocked["Floor 1-2"]:
			spawn_tower_entrance_map() #need to check how many checkpoints unlocked
		else:
			go_to_test_floor()
			
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

	if Input.is_action_just_pressed("interact") and player_in_dojo_range and PlayerStats.check_level_for_dojo():
		GameManager.player_can_move = false
		player.velocity = Vector2.ZERO
		spawn_dojo_menu()

func add_tech_tree_to_scene() -> void:
	player.velocity = Vector2.ZERO
	var tech_tree : TechTree = preload("uid://b7n3fwd3y85wp").instantiate()
	sub_viewport.add_child(tech_tree)

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
	var tower_entrance_map : TowerEntranceMap = preload("uid://bgurt44iah13x").instantiate()
	control.add_child(tower_entrance_map)

func spawn_grand_market() -> void:
	var market : GrandMarketMenu = preload("uid://cfuw5h0apwpq").instantiate()
	control.add_child(market)

func spawn_cooking_menu() -> void:
	var cooking_range : CookingMenu = preload("uid://cotvjq5dygv7p").instantiate()
	control.add_child(cooking_range)

func spawn_smelting_menu() -> void:
	var smelting_station : SmeltingMenu = preload("uid://dtf6m65mtihb8").instantiate()
	control.add_child(smelting_station)

func spawn_crafting_menu() -> void:
	var sword_crafting_station : CraftingStationMenu = preload("uid://cc1xppx3tkq4f").instantiate()
	control.add_child(sword_crafting_station)
	
func spawn_dojo_menu() -> void:
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
	temp_cooking_range.unlock_station()
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
	temp_smelting_station.unlock_station()
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


func _on_dojo_area_body_entered(body: Node2D) -> void:
	if body is Player:
		
		if PlayerStats.player_stats["Level"] >= 10:
			dojo_access_notification.text = "Press E to access the Dojo!"
		else:
			dojo_access_notification.text = ""
		
		player_in_dojo_range = true
		dojo_access_notification.show()


func _on_dojo_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_dojo_range = false
		dojo_access_notification.hide()
