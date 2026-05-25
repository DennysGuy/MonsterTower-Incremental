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



@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expedition_time_tracker.text = "Expedition Time: %s seconds" % PlayerStats.player_stats["Expedition Time"]
	update_progress()
	show_tech_tree_buttons()
	add_combat_tech_tree()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		upgrade_tracker_button.text = "Promote License!"
		upgrade_tracker_button.disabled = false
	else:
		upgrade_tracker_button.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
		upgrade_tracker_button.disabled = true

	upgrade_progress_bar.max_value = TechTreeManager.upgrade_count_to_prestige
	upgrade_progress_bar.value = TechTreeManager.current_upgrade_count

func add_combat_tech_tree() -> void:
	if sub_viewport.get_child(0):
		sub_viewport.get_child(0).queue_free()
	var combat_tech_tree : CombatTechTree = preload("uid://bpcgnubcykkw2").instantiate()
	sub_viewport.add_child(combat_tech_tree)


func _on_combat_page_button_button_up() -> void:
	add_combat_tech_tree()

func show_tech_tree_buttons() -> void:
	for button in tech_tree_buttons_h_box.get_children():
		button.show()
		await get_tree().create_timer(0.1).timeout
