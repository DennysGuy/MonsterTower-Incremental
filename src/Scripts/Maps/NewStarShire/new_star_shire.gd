class_name NewStarShireMap extends Map

@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport
@onready var guide_log: Label = $GuideLog
@onready var guide_log_2: Label = $GuideLog2
@onready var control: Control = $CanvasLayer/Control
@onready var enter_market_label: Label = $EnterMarketLabel
@onready var access_crafting_station: Label = $AccessCraftingStation
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var dojo_position: Node2D = $DojoPosition

var sell_speed_timer : float = 0.0
var sell_speed : float = 100

const NOVELTY_ITEMS_SALE = preload("uid://bylwk3imxuh3i")

var player_in_tower_range : bool = false
var player_in_market_range : bool = false
var player_in_cooking_range : bool = false
var player_in_smelting_range : bool = false
var player_in_crafting_range : bool = false
var player_in_dojo_range : bool = false
var player_in_upgrade_station_range : bool = false
var player_in_kioske_range : bool = false
var can_sell_to_market : bool = false
var sell_timer_set : bool = false

const CRAFTING_STATION_OPEN = preload("uid://ccqpi3mcw8aww")



@onready var access_smelting_station: Label = $AccessSmeltingStation
@onready var access_sword_crafting_station: Label = $AccessSwordCraftingStation
@onready var dojo_area: Area2D = $Dojo/DojoArea

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
@onready var grand_market_position: Marker2D = $GrandMarketPosition
@onready var enter_kioske_label: Label = $EnterKioskeLabel
@onready var bulk_grand_market_menu: BulkSellerGrandMarketMenu = $BulkGrandMarketMenu

const CLASS_UP_FANFARE = preload("uid://cw28u06grrwni")

const CRAFT_SWORD = preload("uid://4c6l1w0kpar3")
const UNLOCK_SHOP = preload("uid://cveiqvxm5r0yw")
@onready var grand_market_area: Area2D = $GrandMarketArea

const TUTORIAL_CUTSCENE = preload("uid://cvhk4xt8ju43w") 
const LEVEL_UP_INSTRUCTION = preload("uid://7k2f4h2w0i08")
const COOKING_STATION_UNLOCK_SCENE = preload("uid://gfqitaq4h4ol")
const SMELTING_STATION_UNLOCK_SCENE = preload("uid://dknm38b28himr")
const GEMS_STATION_UNLOCK_SCENE = preload("uid://blac36hlx22lb")
const GO_TO_JOB_BOARD = preload("uid://iqw8ymk767kl")

const STARSPIRE_MARKET_INTRO = preload("uid://b3l8f4fxsjhu6")
const HEAD_TO_JOB_ADVANCEMENT_CENTER_FOR_CLASS = preload("uid://bc68ocr4ayjpd")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	CutsceneManager.enable_player_functionality()
	CutsceneManager.set_camera_to_player_pos.connect(set_camera_to_player_pos)
	CutsceneManager.set_camera_to_dojo_pos.connect(set_camera_to_dojo_position)
	CutsceneManager.send_camera_to_cooking_station.connect(send_camera_to_cooking_station)
	CutsceneManager.send_camera_to_market.connect(send_camera_to_market)
	CutsceneManager.send_camera_to_smelting_station.connect(send_camera_to_smelting_station)
	CutsceneManager.send_camera_to_sword_crafting_station.connect(send_camera_to_sword_crafting_station)
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	SignalBus.issue_can_craft_sword_scene.connect(new_sword_unlock_notice)
	SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)
	SignalBus.spawn_class_selection_menu.connect(spawn_dojo_menu)
	SignalBus.spawn_tower_map.connect(spawn_tower_entrance_map)
	SignalBus.play_warrior_unlock_animation.connect(warrior_class_unlocked_notice)
	SignalBus.spawn_warrior_tech_tree.connect(warrior_class_unlocked_notice)
	SignalBus.combat_class_menu_closed.connect(show_ap_notice)
	SignalBus.gem_stone_menu_closed.connect(show_gem_station_notice)
	TechTreeManager.unlock_station.connect(unlock_station)
	HubManager.check_for_node_purchase.connect(check_for_node_purchase)
	#SignalBus.show_ap_notice.connect(show_ap_notice)

	TechTreeManager.update_currency_label.emit()
	InventoryManager.show_bank_button.emit()
	CookingManager.can_craft_bar.emit()
	#hud.animation_player.play("CloseIn")
	
	await get_tree().process_frame
	
	GameManager.event_speed_mod = 2.5
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	PlayerStats.player_stats["Current MP"] = PlayerStats.player_stats["Max MP"] + PlayerStats.get_current_sword().max_mp_bonus + PlayerStats.get_total_gem_bonus("Max MP Bonus")
	PlayerHudSignalBus.update_player_mp.emit()
	PlayerHudSignalBus.update_player_health.emit()
	SaveManager.save_player_stats()
	QuestManager.check_map_name.emit(map_name)
	show_ap_notice()
	show_gem_station_notice()
	check_for_node_purchase()
	
	if !GameManager.market_intro_cutscene_played:
		MusicPlayer.stop_player()
		MusicPlayer.play_song(TUTORIAL_CUTSCENE)
		Dialogic.start(STARSPIRE_MARKET_INTRO)
		GameManager.market_intro_cutscene_played = true
		SaveManager.save_progression_state("Market Intro Cutscene Played", true)

	if PlayerStats.player_stats["Level"] == 2 and PlayerStats.player_stats["Ability Points"] == 1:
		#ability_station_notice()
		MusicPlayer.stop_player()
		MusicPlayer.play_song(TUTORIAL_CUTSCENE)
		Dialogic.start(LEVEL_UP_INSTRUCTION)
	
	if PlayerStats.player_stats["Level"] >= 8 and PlayerStats.player_stats["Class"] == "Junior Hunter" and !GameManager.job_selection_notice_scene_played:
		Dialogic.start(HEAD_TO_JOB_ADVANCEMENT_CENTER_FOR_CLASS)
		GameManager.job_selection_notice_scene_played = true
		SaveManager.save_progression_state("Job Selection Notice Cutscene Played", true)

func _exit_tree() -> void:
	GameManager.event_speed_mod = 1.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("interact") and player_in_tower_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Hunter License"]:
		player.velocity = Vector2.ZERO
		spawn_tower_entrance_map()

	if Input.is_action_just_pressed("interact") and player_in_kioske_range:
		player.velocity = Vector2.ZERO
		spawn_grand_market()

	if Input.is_action_pressed("interact") and player_in_market_range and can_sell_to_market:
		print("HIHI")
		player.velocity = Vector2.ZERO
		sell_to_market(delta)
		
	if Input.is_action_just_pressed("interact") and player_in_cooking_range and GameManager.player_can_move and PlayerStats.facilities_unlocked["Junk-A-Tron"]:
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
	GameManager.can_open_tower_map = false
	GameManager.can_open_bag = false
	GameManager.player_can_move = false
	GameManager.can_pause_game = false
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_tech_tree.emit()

func hide_tech_tree_canvas_layer() -> void:
	canvas_layer.hide()

func set_guide_log(guide_log : Label, show_log : bool) -> void:
	if show_log:
		guide_log.show()
	else:
		guide_log.hide()
	
	if PlayerStats.facilities_unlocked["Hunter License"]:
		var mapping : String = GameManager.get_control_mapping("interact")
		guide_log.text = "Press %s to enter the tower!" % mapping
		GameManager.play_sfx(CRAFTING_STATION_OPEN)
	else:
		guide_log.text = "You need a Tower pass before you can Enter..."

func _on_tower_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = true
		set_guide_log(guide_log, true)

func show_ap_notice() -> void:
	if PlayerStats.player_stats["Ability Points"] >= 1:
		HubManager.show_facility_notification.emit("Class Advance Center")
	else:
		HubManager.hide_facility_notification.emit("Class Advance Center")

func show_gem_station_notice() -> void:
	if InventoryManager.inventories["Gem Stones"].size() > 0:
		HubManager.show_facility_notification.emit("Gem Stone Station")
	else:
		HubManager.hide_facility_notification.emit("Gem Stone Station")

func _on_tower_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = false
		set_guide_log(guide_log, false)

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
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO

	PlayerHudSignalBus.spawn_tower_entrance_map.emit()

func spawn_grand_market() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_market.emit()

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
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_sword_crafting_station.emit()

func spawn_upgrade_menu() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_gem_stone_station.emit()

func spawn_beginner_tree() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_beginner_tree.emit()

func spawn_warrior_tech_tree() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_warrior_menu.emit()

func spawn_dojo_menu() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	
	PlayerHudSignalBus.spawn_class_selection_menu.emit()

func spawn_job_board_menu() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	
	PlayerHudSignalBus.spawn_job_board_menu.emit()

func send_camera_to_market() -> void:
	camera.player = null
	camera.global_position = grand_market_position.global_position

func send_camera_to_smelting_station() -> void:
	camera.player  = null
	camera.global_position = refinery_position.global_position

func send_camera_to_cooking_station() -> void:
	camera.player  = null
	camera.global_position = cooking_range_position.global_position

func send_camera_to_sword_crafting_station() -> void:
	camera.player  = null
	camera.global_position = sword_crafting_station_position.global_position

func send_camera_to_class_advancement_center() -> void:
	camera.player  = null
	camera.global_position = dojo_area.global_position
	
func _on_grand_market_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = true
		#sell_novelty_items()
		#check_for_node_purchase()
		var mapping : String = GameManager.get_control_mapping("interact")
		GameManager.play_sfx(CRAFTING_STATION_OPEN)
		if player.junk_picked_up.size() > 0:
			can_sell_to_market = true
			enter_market_label.text = "Press and hold %s to sell Novelty Inventions! (%s)" % [mapping, player.junk_picked_up.size()]
			bulk_grand_market_menu.fade_in()
		else:
			can_sell_to_market = false
			enter_market_label.text = "Produce some Novelty Inventions to sell!" % mapping
		enter_market_label.show()
		

func _on_grand_market_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = false
		if can_sell_to_market:
			bulk_grand_market_menu.fade_out()
			can_sell_to_market = false
		enter_market_label.hide()

func _on_cooking_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_cooking_range = true
		if !PlayerStats.facilities_unlocked["Junk-A-Tron"]:
			access_crafting_station.text = "Junk-A-Tron under construction!"
		else:
			var mapping : String = GameManager.get_control_mapping("interact")
			access_crafting_station.text = "Press %s to access Cooking Range" % mapping
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
			var mapping : String = GameManager.get_control_mapping("interact")
			access_smelting_station.text = "Press %s to access Refinery" % mapping
		access_smelting_station.show()

func _on_smelting_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_smelting_range = false
		access_smelting_station.hide()

func _on_crafting_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if PlayerStats.player_stats["Tracked Weapon"] > 2 and PlayerStats.player_stats["Class"] == "Junior Hunter":
			player_in_crafting_range = false
			access_sword_crafting_station.text = "Select your Class to Gain Access"
		else:
			player_in_crafting_range = true
			GameManager.play_sfx(CRAFTING_STATION_OPEN)
			var mapping : String = GameManager.get_control_mapping("interact")
			access_sword_crafting_station.text = "Press %s to access Sword Crafting Station" % mapping
			
		access_sword_crafting_station.show()
	
func _on_crafting_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_crafting_range = false
		access_sword_crafting_station.hide()

func unlock_cooking_station() -> void:
	camera.player = null
	CutsceneManager.disable_player_functionality()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	sfx_player.play_sfx(UNLOCK_SHOP)
	camera.position = cooking_range_position.position
	await get_tree().create_timer(1.0).timeout
	PlayerHudSignalBus.flash_screen.emit()
	await get_tree().create_timer(0.5).timeout
	cooking_station.unlock_cooking_station()
	await get_tree().create_timer(2.0).timeout
	Dialogic.start(COOKING_STATION_UNLOCK_SCENE)
	PlayerStats.show_cooking_station_unlock_animation = false

	
func unlock_refinery_station() -> void:
	camera.player = null
	camera.position = refinery_position.position
	CutsceneManager.disable_player_functionality()
	await get_tree().create_timer(0.5).timeout
	sfx_player.play_sfx(UNLOCK_SHOP)
	await get_tree().create_timer(1.0).timeout
	hud.animation_player.play("Flash")
	await get_tree().create_timer(0.5).timeout
	refinery.unlock_refinery()
	await get_tree().create_timer(3.0).timeout
	Dialogic.start(SMELTING_STATION_UNLOCK_SCENE)
	PlayerStats.show_refinery_station_unlock_animation = false

func unlock_station() -> void:
	if PlayerStats.show_cooking_station_unlock_animation:
		CutsceneManager.disable_player_functionality()
		await unlock_cooking_station()
	
	if PlayerStats.show_refinery_station_unlock_animation:
		CutsceneManager.disable_player_functionality()
		await unlock_refinery_station()
	
	if PlayerStats.show_gem_station_unlock_animation:
		CutsceneManager.disable_player_functionality()
		await gem_station_unlock_notice()
	
	CutsceneManager.enable_player_functionality()

func new_sword_unlock_notice() -> void:
	CutsceneManager.disable_player_functionality()
	camera.player = null
	player.send_to_idle_state()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	smithing_station.notify_can_craft()
	camera.position = sword_crafting_station_position.position
	PlayerHudSignalBus.issue_big_notification.emit("A New Sword Can Be Unlocked!")
	await get_tree().create_timer(3.5).timeout
	PlayerHudSignalBus.hide_big_notification.emit()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	CutsceneManager.enable_player_functionality()

func warrior_class_unlocked_notice() -> void:
	#GameManager.player_can_move = false
	player.send_to_idle_state()
	spawn_warrior_tech_tree()
	#MusicPlayer.stop_player()
	#sfx_player.play_sfx(UNLOCK_SHOP)
	#PlayerHudSignalBus.flash_screen.emit()
	#play_sfx(CLASS_UP_FANFARE)
	#PlayerHudSignalBus.flash_screen.emit()
	#await get_tree().create_timer(1.5).timeout
	#PlayerHudSignalBus.hide_big_notification.emit()
	#GameManager.player_can_move = true
	#await get_tree().create_timer(8.5).timeout
	#MusicPlayer.play_song(map_theme_song)

func gem_station_unlock_notice() -> void:
	camera.player = null
	player.send_to_idle_state()
	hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	smithing_station.notify_can_craft()
	camera.position = sword_crafting_station_position.position
	CutsceneManager.disable_player_functionality()
	SignalBus.show_gem_station_arrow.emit()
	Dialogic.start(GEMS_STATION_UNLOCK_SCENE)
	await get_tree().create_timer(0.5).timeout
	PlayerStats.show_gem_station_unlock_animation = false

func set_camera_to_player_pos() -> void:
	camera.position = player.position
	camera.player = player
	
func ability_station_notice() -> void:
	camera.player = null
	player.send_to_idle_state()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = dojo_position.position
	
	PlayerHudSignalBus.issue_big_notification.emit("Spend AP acquired from leveling up\n At the Class Advancement Center!")
	await get_tree().create_timer(3.0).timeout
	PlayerHudSignalBus.hide_big_notification.emit()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	PlayerStats.show_gem_station_unlock_animation = false

func _on_dojo_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var mapping : String = GameManager.get_control_mapping("interact")
		dojo_access_notification.text = "Press %s to Access Dojo!" % mapping
		player_in_dojo_range = true
		GameManager.play_sfx(CRAFTING_STATION_OPEN)
		dojo_access_notification.show()

func _on_dojo_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_dojo_range = false
		dojo_access_notification.hide()

func _on_gem_stone_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_upgrade_station_range = true
		if PlayerStats.facilities_unlocked["Gem Stone Station"]:
			var mapping : String = GameManager.get_control_mapping("interact")
			enter_upgrade_station_notice.text = "Press %s to Access\nGem Stone Station" % mapping
			GameManager.play_sfx(CRAFTING_STATION_OPEN)
		else:
			enter_upgrade_station_notice.text = "Unlock Gem Stone\nStation Node to access!"
		enter_upgrade_station_notice.show()

func _on_gem_stone_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_upgrade_station_range = false
		enter_upgrade_station_notice.hide()

func sell_all_items(inventory_name : String) -> Array:
	var inventory : Array = InventoryManager.inventories[inventory_name]
	var total_sale_numbers : int = 0
	var currency_acquired : int = 0

	for slot in inventory.duplicate():
		if slot["item"].is_novelty():
			var qty = slot["quantity"]
			var value = slot["item"].sell_value * qty
			
			for i in range(qty):
				InventoryManager.remove_item(inventory_name, slot["item"])
			
			TechTreeManager.currency += value
			currency_acquired += value
			total_sale_numbers += qty
			QuestManager.decrement_task_item_gather_count.emit(slot["item"])
			
	TechTreeManager.update_currency_label.emit()
	return [total_sale_numbers,currency_acquired]

func sell_novelty_items() -> void:
	var total_sales : int = 0
	var currency_acquired : int = 0
	var inventory_sales : Array = sell_all_items("Inventory")
	var bank_sale : Array = sell_all_items("Bank")
	
	total_sales += inventory_sales[0]
	currency_acquired += inventory_sales[1]
	total_sales += bank_sale[0]
	currency_acquired += bank_sale[1]
	
	if total_sales > 0:
		var notification_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
		notification_label.label.text = "%s Novelty Items Sold!\n +%s Gold!" % [total_sales,currency_acquired]
		notification_label.position = grand_market_area.position
		add_child(notification_label)
		sfx_player.play_sfx(NOVELTY_ITEMS_SALE)

func set_camera_to_dojo_position() -> void:
	camera.player = null
	camera.position = dojo_position.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Dialogic.start('uid://buaw4ymemp3ln')

func check_for_node_purchase() -> void:
	var tech_node_stats_dict := TechTreeManager.tech_node_stats
	
	for key in tech_node_stats_dict:
		var tech_node_stats : TechNodeStats = tech_node_stats_dict[key]
		if can_purchase(tech_node_stats) and tech_node_stats.stat_relation != TechTreeManager.STAT_RELATION.LICENSE:
			HubManager.show_facility_notification.emit("Upgrades PC")
			return
	HubManager.hide_facility_notification.emit("Upgrades PC")
	
func can_purchase(tech_node_stats : TechNodeStats) -> bool:
	if SaveManager.current_save_game:
		var tech_node_name : String = tech_node_stats.node_name
		var saved_data = SaveManager.current_save_game.tech_nodes.get(tech_node_name)
		tech_node_stats.current_level = saved_data["Level"]
		tech_node_stats.unlocked = saved_data["Unlocked"]
		TechTreeManager.tech_nodes[tech_node_stats.node_name] = saved_data["Level"]
		
	return TechTreeManager.currency >= tech_node_stats.currency_required and has_resource_quantity(tech_node_stats) and tech_node_stats.current_level < tech_node_stats.max_level and tech_node_stats.unlocked

func has_resource_quantity(tech_node_stats : TechNodeStats) -> bool:
	if tech_node_stats.materials_required.is_empty():
		return true

	for resource in tech_node_stats.materials_required:
		for item in resource.keys():
			match item.item_type:
				item.ITEM_TYPE.CRAFTING:
					if InventoryManager.get_quantity(item, "Crafting Items") < resource[item]:
						return false
				item.ITEM_TYPE.COOKING:
					if InventoryManager.get_quantity(item, "Cooking Items") < resource[item]:
						return false
				item.ITEM_TYPE.ORE:
					if InventoryManager.get_quantity(item, "Ore") < resource[item]:
						return false
				item.ITEM_TYPE.USE:
					if InventoryManager.get_quantity(item, "Use") < resource[item]:
						return false
		
	return true		

func sell_to_market(delta: float) -> void:
	if player.junk_picked_up.is_empty():
		return

	sell_speed_timer += delta

	var interval := get_sell_time()
	print(interval)
	if sell_speed_timer >= interval:
		sell_speed_timer -= interval

		var item: ItemInteractable = player.junk_picked_up.front()
		item.set_to_sold(grand_market_position)

func get_sell_time() -> float:
	var sell_speed_level : int = SaveManager.get_tech_node_stat_level("Bulk Sell Transfer Speed")
	return max(0.03, PlayerStats.BASE_TRANSFER_TIME * pow(0.7, sell_speed_level))

func _on_tower_area_2_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = true
		set_guide_log(guide_log_2, true)


func _on_tower_area_2_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = false
		set_guide_log(guide_log_2, false)


func _on_market_kioske_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_kioske_range = true
		enter_kioske_label.show()


func _on_market_kioske_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_kioske_range = false
		enter_kioske_label.hide()
