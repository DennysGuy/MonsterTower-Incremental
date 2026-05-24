class_name NewTechTree extends Control

@onready var combat_page_button: Button = $HBoxContainer/CombatPageButton
@onready var survival_page_button: Button = $HBoxContainer/SurvivalPageButton
@onready var traversal_page_button: Button = $HBoxContainer/TraversalPageButton
@onready var inventory_page_button: Button = $HBoxContainer/InventoryPageButton
@onready var cooking_page_button: Button = $HBoxContainer/CookingPageButton
@onready var crafting_page_button: Button = $HBoxContainer/CraftingPageButton
@onready var upgrade_tracker_button: Button = $UpgradeTrackerButton
@onready var expedition_time_tracker: Label = $ExpeditionTimeTracker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expedition_time_tracker.text = "Expedition Time: %s seconds" % PlayerStats.player_stats["Expedition Time"]
	upgrade_tracker_button.text = "[%s/%s]" %[TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]

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
	tween.tween_property(button, "scale",Vector2(1.1,1.1),0.1)

func button_to_normal(button : Button) -> void:
	if button.disabled:
		return
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(button, "scale",Vector2(1.0,1.0),0.1)


func _on_upgrade_tracker_button_mouse_entered() -> void:
	expand_button(upgrade_tracker_button)


func _on_upgrade_tracker_button_mouse_exited() -> void:
	button_to_normal(upgrade_tracker_button)
