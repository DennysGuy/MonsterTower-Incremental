class_name NewTechTree extends Control

@onready var combat_page_button: Button = $TechTreeButtonsHBox/CombatPageButton
@onready var survival_page_button: Button = $TechTreeButtonsHBox/SurvivalPageButton
@onready var traversal_page_button: Button = $TechTreeButtonsHBox/TraversalPageButton
@onready var inventory_page_button: Button = $TechTreeButtonsHBox/InventoryPageButton
@onready var cooking_page_button: Button = $TechTreeButtonsHBox/CookingPageButton
@onready var crafting_page_button: Button = $TechTreeButtonsHBox/CraftingPageButton
@onready var tech_tree_buttons_h_box: HBoxContainer = $TechTreeButtonsHBox

@onready var upgrade_progress_bar: TextureProgressBar = $UpgradeProgressBar
@onready var expedition_time_tracker: Label = $ExpeditionTimeTracker
@onready var upgrade_tracker_button: Button = $UpgradeTrackerButton

@onready var card_view_port_container: SubViewportContainer = $CardViewPortContainer
@onready var card_view_sub_viewport: SubViewport = $CardViewPortContainer/CardViewSubViewport

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var upgrade_button_notification_icon: TextureRect = $UpgradeButtonNotificationIcon

@onready var close_button: Button = $CloseButton
@onready var currency_label: Label = $CurrencyLabel
@onready var license_tier: Label = $LicenseTier

var stored_message_panel : TechTreeMessagePanel
@onready var music_player: AudioStreamPlayer = $MusicPlayer
const ENTER_TECH_TREE = preload("uid://7faujn4ldspq")
const EXIT_TECH_TREE = preload("uid://dfpttuw4h2wa1")
const BUTTON_APPEAR = preload("uid://bvnkpmsp7xinb")
const CLICK_BUTTON = preload("uid://d2a7rj3wvxd30")
const CLICK_NODE = preload("uid://bawqj0b2h6vsu")

@onready var combat_page_notification_icon: TextureRect = $TechTreeButtonsHBox/CombatPageButton/CombatPageNotificationIcon
@onready var survival_notification_icon: TextureRect = $TechTreeButtonsHBox/SurvivalPageButton/SurvivalNotificationIcon
@onready var traversal_notification_icon: TextureRect = $TechTreeButtonsHBox/TraversalPageButton/TraversalNotificationIcon
@onready var inventory_notification_icon: TextureRect = $TechTreeButtonsHBox/InventoryPageButton/InventoryNotificationIcon
@onready var cooking_notification_icon: TextureRect = $TechTreeButtonsHBox/CookingPageButton/CookingNotificationIcon
@onready var crafting_notification_icon: TextureRect = $TechTreeButtonsHBox/CraftingPageButton/CraftingNotificationIcon

const TECH_TREE_EXPLANATION = preload("uid://g6243qefq3ht")

var can_close = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.check_for_tech_node_purchases.connect(check_for_purchases)
	CutsceneManager.disable_close_function.connect(disable_close_function)
	CutsceneManager.enable_close_function.connect(enable_close_function)
	check_for_purchases()
	MusicPlayer.pause_music()
	music_player.play()
	play_sfx(ENTER_TECH_TREE)
	SignalBus.flash_screen.connect(flash_screen)
	SignalBus.close_message_panel.connect(remove_message_panel)
	TechTreeManager.update_currency_label.connect(update_progress)
	expedition_time_tracker.text = "Expedition Time: %s seconds" % PlayerStats.player_stats["Expedition Time"]
	update_progress()
	print("THIS IS CURERENT PRESTIGE %s" % TechTreeManager.current_prestige)
	if TechTreeManager.current_prestige > 0:
		show_tech_tree_buttons()
		add_combat_tech_tree()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu") and can_close:
		close_out()
	
	#if Input.is_action_just_pressed("add_currency"):
		#TechTreeManager.currency += 500
		#PlayerStats.player_stats["Current XP"] += 500
		#LevelingManager.check_for_level_up()
		#update_currency_label()
		#TechTreeManager.check_if_can_purchase_node.emit()

func _on_combat_page_button_mouse_entered() -> void:
	expand_button(combat_page_button)

func _on_combat_page_button_mouse_exited() -> void:
	button_to_normal(combat_page_button)

func _on_survival_page_button_mouse_entered() -> void:
	expand_button(survival_page_button)

func _on_survival_page_button_mouse_exited() -> void:
	button_to_normal(survival_page_button)

func _on_traversal_page_button_mouse_entered() -> void:
	expand_button(traversal_page_button)

func _on_traversal_page_button_mouse_exited() -> void:
	button_to_normal(traversal_page_button)

func _on_inventory_page_button_mouse_entered() -> void:
	expand_button(inventory_page_button)

func _on_inventory_page_button_mouse_exited() -> void:
	button_to_normal(inventory_page_button)

func _on_cooking_page_button_mouse_entered() -> void:
	expand_button(cooking_page_button)

func _on_cooking_page_button_mouse_exited() -> void:
	button_to_normal(cooking_page_button)

func _on_crafting_page_button_mouse_entered() -> void:
	expand_button(crafting_page_button)

func _on_crafting_page_button_mouse_exited() -> void:
	button_to_normal(crafting_page_button)

func expand_button(button : Button) -> void:
	if button.disabled:
		return
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(button, "scale",Vector2(1.05,1.05),0.1)

func button_to_normal(button : Button) -> void:
	if button.disabled:
		return
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(button, "scale",Vector2(1.0,1.0),0.1)

func disable_close_function() -> void:
	can_close = false
	close_button.disabled = true

func enable_close_function() -> void:
	can_close = true
	close_button.disabled = false

func _on_upgrade_tracker_button_mouse_entered() -> void:
	expand_button(upgrade_tracker_button)

func _on_upgrade_tracker_button_mouse_exited() -> void:
	button_to_normal(upgrade_tracker_button)

func update_progress() -> void:
	if TechTreeManager.current_upgrade_count >= TechTreeManager.upgrade_count_to_prestige:
		if TechTreeManager.current_prestige == 0:
			GameManager.license_promotion_time = true
			upgrade_tracker_button.text = "Receive Hunter's License"
			upgrade_button_notification_icon.show()
		else:
			GameManager.license_promotion_time = true
			upgrade_button_notification_icon.show()
			upgrade_tracker_button.text = "Promote License"
			license_tier.hide()
		upgrade_tracker_button.disabled = false
		
	else:
		upgrade_tracker_button.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
		upgrade_tracker_button.disabled = true
		license_tier.show()
		license_tier.text = "License Tier: %s" % TechTreeManager.current_prestige
		upgrade_button_notification_icon.hide()
	
	expedition_time_tracker.text = "Expedition Time: %s" % PlayerStats.player_stats["Expedition Time"]
	currency_label.text = "Spirols %s" % [TechTreeManager.currency]
	upgrade_progress_bar.max_value = TechTreeManager.upgrade_count_to_prestige
	upgrade_progress_bar.value = TechTreeManager.current_upgrade_count
	
func add_combat_tech_tree() -> void:
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var combat_tech_tree: CombatTechTree = preload("uid://bpcgnubcykkw2").instantiate()
	sub_viewport.add_child(combat_tech_tree)

	await combat_tech_tree.ready

func add_survival_tech_tree() -> void:
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var survival_tech_tree: SurvivalTechTree = preload("uid://chlt23hkgrbk5").instantiate()
	sub_viewport.add_child(survival_tech_tree)

	await survival_tech_tree.ready

func add_traversal_tech_tree() -> void:
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var traversal_tech_tree: TraversalTechTree = preload("uid://ngqtevyit7sv").instantiate()
	sub_viewport.add_child(traversal_tech_tree)

func add_inventory_tech_tree() -> void:
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var inventory_tech_tree: InventoryTechTree = preload("uid://b4uckmtmr7vfn").instantiate()
	sub_viewport.add_child(inventory_tech_tree)	

func add_refinery_tech_tree() -> void:
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var inventory_tech_tree: SmeltingTechTree = preload("uid://cgdswp5f76gxo").instantiate()
	sub_viewport.add_child(inventory_tech_tree)	

func add_cooking_tech_tree() -> void:
	
	for child in sub_viewport.get_children():
		child.queue_free()

	await get_tree().process_frame

	var inventory_tech_tree: CookingTechTree = preload("uid://cf3ufg772gluf").instantiate()
	sub_viewport.add_child(inventory_tech_tree)	

func show_tech_tree_buttons() -> void:
	for button in tech_tree_buttons_h_box.get_children():
		button.show()
		play_sfx(BUTTON_APPEAR)
		await get_tree().create_timer(0.1).timeout
	
	play_sfx(BUTTON_APPEAR)
	upgrade_progress_bar.show()
	await get_tree().create_timer(0.15).timeout
	play_sfx(BUTTON_APPEAR)
	expedition_time_tracker.show()
	

func play_license_upgrade_sequence() -> void:
	card_view_port_container.show()
	var hunter_license : HunterLicense = preload("uid://dta71ficj4siw").instantiate()
	card_view_sub_viewport.add_child(hunter_license)
	await get_tree().create_timer(5.0).timeout
	update_progress()
	show_tech_tree_buttons()
	card_view_port_container.hide()
	add_combat_tech_tree()
	await get_tree().process_frame
	insert_message_panel()
	GameManager.license_promotion_time = false
	music_player.stream_paused = false

func flash_screen() -> void:
	animation_player.play("FlashScreen")

func _on_upgrade_tracker_button_button_up() -> void:
	play_sfx(CLICK_NODE)
	music_player.stream_paused = true
	
	if TechTreeManager.current_prestige == 0:
		unlock_hunter_license()
	
	play_license_upgrade_sequence()

func close_out() -> void:
	TechTreeManager.check_needed_item_panel_for_purchase.emit()
	TechTreeManager.set_ability_hud_icon.emit()
	GameManager.can_open_bag = true
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	music_player.stop()
	play_sfx(EXIT_TECH_TREE)
	MusicPlayer.unpause_music()
	if station_unlock_available():
		TechTreeManager.unlock_station.emit()
	#sfx_player.play_sfx(CLOSE_UPGRADE_PC)
	HubManager.check_for_node_purchase.emit()
	await get_tree().create_timer(0.3).timeout
	
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func station_unlock_available() -> bool:
	return PlayerStats.show_cooking_station_unlock_animation or PlayerStats.show_refinery_station_unlock_animation or PlayerStats.show_gem_station_unlock_animation

func _on_close_button_mouse_entered() -> void:
	expand_button(close_button)

func _on_close_button_mouse_exited() -> void:
	button_to_normal(close_button)

func _on_close_button_button_up() -> void:
	close_out()

func unlock_hunter_license() -> void:
	TechTreeManager.tech_nodes["Hunter License"] += 1
	PlayerStats.facilities_unlocked["Hunter License"] = true
	QuestManager.check_node_name.emit("Hunter License")
	SaveManager.save_tech_tree_data()
	SaveManager.save_player_stats()
	SaveManager.save_game()
	
func update_currency_label() -> void:
	update_progress()

func _on_combat_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_combat_tech_tree()

func _on_survival_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_survival_tech_tree()

func _on_traversal_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_traversal_tech_tree()

func _on_inventory_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_inventory_tech_tree()

func _on_crafting_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_refinery_tech_tree()

func _on_cooking_page_button_button_up() -> void:
	play_sfx(CLICK_BUTTON)
	add_cooking_tech_tree()


func insert_message_panel() -> void:
	disable_close_function()
	var message_panel : TechTreeMessagePanel = preload("uid://bsqvfj57myih2").instantiate()

	add_child(message_panel)

	message_panel.global_position = Vector2(730, 1140)

	stored_message_panel = message_panel

	var tween : Tween = create_tween()
	tween.tween_property(
		message_panel,
		"global_position",
		Vector2(730, 437),
		0.15
	)

	await tween.finished

func remove_message_panel() -> void:
	if stored_message_panel:
		var tween : Tween = create_tween()
		tween.tween_property(stored_message_panel, "global_position", Vector2(730,1140),0.2)
		await tween.finished
		stored_message_panel.queue_free()
		if TechTreeManager.current_prestige == 1:
			Dialogic.start(TECH_TREE_EXPLANATION)
		else:
			enable_close_function()
	

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func check_for_purchases() -> void:
	combat_page_notification_icon.hide()
	survival_notification_icon.hide()
	traversal_notification_icon.hide()
	inventory_notification_icon.hide()
	cooking_notification_icon.hide()
	crafting_notification_icon.hide()
	
	var tech_node_stats_dict := TechTreeManager.tech_node_stats
	
	for key in tech_node_stats_dict:
		var tech_node_stats : TechNodeStats = tech_node_stats_dict[key]
		if can_purchase(tech_node_stats):
			match tech_node_stats.stat_relation:
				TechTreeManager.STAT_RELATION.COMBAT:
					combat_page_notification_icon.show()
				TechTreeManager.STAT_RELATION.SURVIVAL:
					survival_notification_icon.show()
				TechTreeManager.STAT_RELATION.TRAVERSAL:
					traversal_notification_icon.show()
				TechTreeManager.STAT_RELATION.INVENTORY:
					inventory_notification_icon.show()
				TechTreeManager.STAT_RELATION.COOKING:
					cooking_notification_icon.show()
				TechTreeManager.STAT_RELATION.CRAFTING:
					crafting_notification_icon.show()


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
