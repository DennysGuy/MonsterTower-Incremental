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
@onready var sparks_location: Marker2D = $SparksLocation

const COOKING_NOTIFICATION = preload("uid://cm0j8tdbmvlhb")
const CRAFTING_NOTIFICATION = preload("uid://wyjbs57smen4")
const QUEST_FINISHED_NOTIFICATION = preload("uid://cajff8jn8ngda")
const SMELTING_NOTIFICATION = preload("uid://qxr3eldptgko")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.check_for_notification.connect(check_for_notification)
	set_icon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_icon() -> void:
	match icon_type:
		ICON_TYPE.CRAFTING:
			if PlayerStats.can_craft_weapon():
				if !is_enabled:
					icon.texture = GEAR_NOTIFICATION_ICON_ENABLED
					notice.text = "Gear ready to craft!"
					is_enabled = true
					HubManager.show_facility_notification.emit("Weapon Crafting Station")
					play_sfx(CRAFTING_NOTIFICATION)
					start_pulse()
			else:
				stop_pulse()
				HubManager.hide_facility_notification.emit("Weapon Crafting Station")
				icon.texture = GEAR_NOTIFICATION_ICON_DISABLED
				is_enabled = false
					
		ICON_TYPE.COOKING:
			if populate_craftable_items_list(CookingManager.cooking_recipes):
				if !is_enabled:
					play_sfx(COOKING_NOTIFICATION)
					icon.texture = COOKING_NOTIFICATION_ICON_ENABLED
					notice.text = "Recipes ready to craft!"
					HubManager.show_facility_notification.emit("Junk-A-Tron")
					is_enabled = true
					start_pulse()
			else:
				stop_pulse()
				icon.texture = COOKING_NOTIFICATION_ICON_DISABLED
				HubManager.hide_facility_notification.emit("Junk-A-Tron")
				is_enabled = false
					
		ICON_TYPE.SMELTING:
			if populate_craftable_items_list(CookingManager.smelting_recipes):
				if !is_enabled:
					play_sfx(SMELTING_NOTIFICATION)
					notice.text= "Bar ready to smelt!"
					icon.texture = SMELTING_NOTIFICATION_ICON_ENABLED
					is_enabled = true
					HubManager.show_facility_notification.emit("Smelting Station")
					start_pulse()
			else:
				stop_pulse()
				icon.texture = SMELTING_NOTIFICATION_ICON_DISABLED
				HubManager.hide_facility_notification.emit("Smelting Station")
				is_enabled = false
				
		ICON_TYPE.AP:
			if PlayerStats.player_stats["Ability Points"] >= 1:
				if !is_enabled:
					start_pulse()
					is_enabled = true
				notice.text = "AP ready to spend!\nAp Available: %s" % PlayerStats.player_stats["Ability Points"]
				icon.texture = AP_NOTIFICATION_ICON_ENABLED
			else:
				stop_pulse()
				icon.texture = AP_NOTIFICATION_ICON_DISABLED
				is_enabled = false

		ICON_TYPE.QUEST:
			if GameManager.new_jobs_available:
				if !is_enabled:
					start_pulse()
					is_enabled = true
				notice.text = "New Job Request are Available!"
				icon.texture = QUEST_NOTIFICATION_ICON_ENABLED
			else:
				stop_pulse()
				icon.texture = QUEST_NOTIFICATION_ICON_DISABLED
				is_enabled = false
				notice.text = "Look for Job Requests for bonus rewards!"
		
func populate_craftable_items_list(recipe_list : Dictionary) -> bool:
	for tier in recipe_list.keys():
		for recipe in recipe_list[tier]:
			var quantity : int = InventoryManager.calculate_quantity(recipe)
			if quantity >= 1:
				return true
	
	return false


func check_for_notification(notification_type : GameManager.NOTIFICATION_TYPE) -> void:
	if icon_type != notification_type:
		return
	
	set_icon()

'''
The goal is to set the icon to enabled - but only do it once. 
if it is already enabled, we won't set the icon enabled. 
'''

func start_pulse() -> void:
	spawn_sparks()
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

func spawn_sparks() -> void:
	var sparks = preload("uid://caecanj86lyrx").instantiate()
	sparks.position = sparks_location.position
	add_child(sparks)

func _on_mouse_entered() -> void:
	if is_enabled:
		panel_container.show()


func _on_mouse_exited() -> void:
	if is_enabled:
		panel_container.hide()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
