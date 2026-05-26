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

@onready var close_button: Button = $CloseButton
@onready var currency_label: Label = $CurrencyLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.flash_screen.connect(flash_screen)
	TechTreeManager.update_currency_label.connect(update_currency_label)
	expedition_time_tracker.text = "Expedition Time: %s seconds" % PlayerStats.player_stats["Expedition Time"]
	update_progress()
	if TechTreeManager.current_prestige > 0:
		show_tech_tree_buttons()
		add_combat_tech_tree()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

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


func _on_upgrade_tracker_button_mouse_entered() -> void:
	expand_button(upgrade_tracker_button)


func _on_upgrade_tracker_button_mouse_exited() -> void:
	button_to_normal(upgrade_tracker_button)

func update_progress() -> void:
	if TechTreeManager.current_upgrade_count >= TechTreeManager.upgrade_count_to_prestige:
		if TechTreeManager.current_prestige == 0:
			upgrade_tracker_button.text = "Receive Hunter's License"
		else:
			upgrade_tracker_button.text = "Promote License"
		upgrade_tracker_button.disabled = false
	else:
		upgrade_tracker_button.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
		upgrade_tracker_button.disabled = true

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

func show_tech_tree_buttons() -> void:
	for button in tech_tree_buttons_h_box.get_children():
		button.show()
		await get_tree().create_timer(0.1).timeout
	

	upgrade_progress_bar.show()
	await get_tree().create_timer(0.15).timeout
	expedition_time_tracker.show()
	

func _on_combat_page_button_button_up() -> void:
	add_combat_tech_tree()

func _on_survival_page_button_button_up() -> void:
	add_survival_tech_tree()

func play_license_upgrade_sequence() -> void:
	card_view_port_container.show()
	var hunter_license : HunterLicense = preload("uid://dta71ficj4siw").instantiate()
	card_view_sub_viewport.add_child(hunter_license)
	await get_tree().create_timer(5.0).timeout
	update_progress()
	show_tech_tree_buttons()
	card_view_port_container.hide()
	add_combat_tech_tree()

func flash_screen() -> void:
	animation_player.play("FlashScreen")

func _on_upgrade_tracker_button_button_up() -> void:
	if TechTreeManager.current_prestige == 0:
		unlock_hunter_license()
	
	play_license_upgrade_sequence()


func close_out() -> void:
	TechTreeManager.check_needed_item_panel_for_purchase.emit()
	TechTreeManager.set_ability_hud_icon.emit()
	GameManager.can_open_bag = true
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	
	if station_unlock_available():
		TechTreeManager.unlock_station.emit()
	#sfx_player.play_sfx(CLOSE_UPGRADE_PC)
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
	currency_label.text = "Spirols %s" % TechTreeManager.currency

func _on_traversal_page_button_button_up() -> void:
	add_traversal_tech_tree()

func _on_inventory_page_button_button_up() -> void:
	add_inventory_tech_tree()

func _on_crafting_page_button_button_up() -> void:
	add_refinery_tech_tree()
