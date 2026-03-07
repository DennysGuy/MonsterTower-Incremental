class_name HubNoticiationIcon extends Control

enum ICON_TYPE {CRAFTING, COOKING, SMELTING, AP, QUEST}
@export var icon_type : ICON_TYPE
var pulse_tween : Tween
@export var aura : TextureRect
@onready var icon: TextureRect = $Icon

var is_enabled : bool = false
@onready var panel_container: PanelContainer = $PanelContainer

const AP_NOTIFICATION_ICON_DISABLED = preload("uid://banlwmpk25ol3")
const AP_NOTIFICATION_ICON_ENABLED = preload("uid://bnm2bg3ccdci")
const COOKING_NOTIFICATION_ICON_DISABLED = preload("uid://d4ca4b4pf887i")
const COOKING_NOTIFICATION_ICON_ENABLED = preload("uid://g3pcqbawyt6h")
const GEAR_NOTIFICATION_ICON_DISABLED = preload("uid://lft6fn0ijwxx")
const GEAR_NOTIFICATION_ICON_ENABLED = preload("uid://b8sgi7i1x3xm")
const QUEST_NOTIFICATION_ICON_DISABLED = preload("uid://c1icypjsfw67r")
const QUEST_NOTIFICATION_ICON_ENABLED = preload("uid://bv8vbtaujqkwx")
const SMELTING_NOTIFICATION_ICON_DISABLED = preload("uid://b73o5qk627hy3")
const SMELTING_NOTIFICATION_ICON_ENABLED = preload("uid://bgq13f8igikbn")
@onready var notice: Label = $PanelContainer/MarginContainer/Notice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_icon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_icon() -> void:
	match icon_type:
		ICON_TYPE.CRAFTING:
			if PlayerStats.can_craft_next_sword():
				icon.texture = GEAR_NOTIFICATION_ICON_ENABLED
				notice.text = "Gear ready to craft!"
				is_enabled = true
				start_pulse()
			else:
				icon.texture = GEAR_NOTIFICATION_ICON_DISABLED
		ICON_TYPE.COOKING:
			if populate_craftable_items_list(CookingManager.cooking_recipes):
				icon.texture = COOKING_NOTIFICATION_ICON_ENABLED
				notice.text = "Dish ready to cook!"
				is_enabled = true
				start_pulse()
			else:
				icon.texture = COOKING_NOTIFICATION_ICON_DISABLED
		ICON_TYPE.SMELTING:
			if populate_craftable_items_list(CookingManager.smelting_recipes):
				notice.text= "Bar ready to smelt!"
				icon.texture = SMELTING_NOTIFICATION_ICON_ENABLED
				is_enabled = true
				start_pulse()
			else:
				icon.texture = SMELTING_NOTIFICATION_ICON_DISABLED
		ICON_TYPE.AP:
			if PlayerStats.player_stats["Ability Points"] >= 1:
				notice.text = "AP ready to spend!\nAp Available: %s" % PlayerStats.player_stats["Ability Points"]
				icon.texture = AP_NOTIFICATION_ICON_ENABLED
				is_enabled = true
				start_pulse()
			else:
				icon.texture = AP_NOTIFICATION_ICON_DISABLED
		ICON_TYPE.QUEST:
			icon.texture = QUEST_NOTIFICATION_ICON_DISABLED

func populate_craftable_items_list(recipe_list : Dictionary) -> bool:
	for tier in recipe_list.keys():
		for recipe in recipe_list[tier]:
			var quantity : int = InventoryManager.calculate_quantity(recipe)
			if quantity >= 1:
				return true
	
	return false


func start_pulse() -> void:
	aura.show()
	if pulse_tween:
		pulse_tween.kill()

	aura.scale = Vector2.ONE
	aura.modulate.a = 0.35

	pulse_tween = create_tween()
	pulse_tween.set_loops()

	pulse_tween.tween_property(aura, "scale", Vector2(1.2, 1.2), 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	pulse_tween.parallel().tween_property(aura, "modulate:a", 0.7, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	pulse_tween.tween_property(aura, "scale", Vector2.ONE, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	pulse_tween.parallel().tween_property(aura, "modulate:a", 0.35, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

func stop_pulse() -> void:
	aura.hide()
	if pulse_tween:
		pulse_tween.kill()

	aura.scale = Vector2.ONE
	aura.modulate.a = 0.0


func _on_mouse_entered() -> void:
	if is_enabled:
		panel_container.show()


func _on_mouse_exited() -> void:
	if is_enabled:
		panel_container.hide()
