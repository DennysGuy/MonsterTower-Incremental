class_name TechTree extends Node2D

@onready var currency: Label = $CanvasLayer/Currency
@onready var presitge_tier: Label = $CanvasLayer/PresitgeTier
@onready var prestige_progress: Label = $CanvasLayer/PrestigeProgress
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var marker_2d: Marker2D = $CanvasLayer/Marker2D
@onready var hunting_time: Label = $CanvasLayer/HuntingTime

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var prestige_progress_2: Label = $CanvasLayer/PrestigeProgress2

const CLOSE_UPGRADE_PC = preload("uid://ckgce5whd3hq7")
const OPEN_UPGRADE_PC = preload("uid://coaqdaythm28l")
const TIER_UP = preload("uid://dhfdudbiidv7a")
@onready var marker_2d_2: Marker2D = $CanvasLayer/Marker2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_prestige_label()
	update_prestige_progress()
	update_currency_label()
	camera_2d.make_current()
	TechTreeManager.update_currency_label.connect(update_currency_label)
	TechTreeManager.update_prestige_tier_label.connect(update_prestige_label)
	TechTreeManager.update_prestige_tier_progress_label.connect(update_prestige_progress)
	TechTreeManager.add_tool_tip.connect(add_tool_tip)
	sfx_player.play_sfx(OPEN_UPGRADE_PC)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("add_currency"):
		TechTreeManager.currency += 500
		PlayerStats.player_stats["Current XP"] += 200
		LevelingManager.check_for_level_up()
		update_currency_label()
		TechTreeManager.check_if_can_purchase_node.emit()
	
	if Input.is_action_just_pressed("close_menu"):
		close_out()
		
func update_currency_label() -> void:
	currency.text = "Currency: %s" % [TechTreeManager.currency]

func update_prestige_label() -> void:
	presitge_tier.text = "License Tier: %s" % [TechTreeManager.current_prestige]
	sfx_player.play_sfx(TIER_UP)

func update_prestige_progress() -> void:
	prestige_progress_2.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
	progress_bar.max_value = TechTreeManager.upgrade_count_to_prestige
	progress_bar.value = TechTreeManager.current_upgrade_count
	hunting_time.text = "Expedition Time: %s sec.\nHunt Challenge Time: %s sec." % [int(PlayerStats.player_stats["Expedition Time"]), int(PlayerStats.player_stats["Hunt Time"])] 
	
func _enter_tree() -> void:
	GameManager.player_can_move = false

func _exit_tree() -> void:
	if PlayerStats.show_cooking_station_unlock_animation or PlayerStats.show_refinery_station_unlock_animation:
		GameManager.player_can_move = false
	else:
		GameManager.player_can_move = true

func _on_close_button_down() -> void:
	close_out()

func close_out() -> void:
	TechTreeManager.check_needed_item_panel_for_purchase.emit()
	TechTreeManager.set_ability_hud_icon.emit()
	if PlayerStats.show_cooking_station_unlock_animation or PlayerStats.show_refinery_station_unlock_animation or PlayerStats.show_gem_station_unlock_animation:
		TechTreeManager.unlock_station.emit()
	sfx_player.play_sfx(CLOSE_UPGRADE_PC)
	await get_tree().create_timer(0.3).timeout
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func add_tool_tip(tool_tip : ToolTip, on_right_half : bool) -> void:
	if on_right_half:
		tool_tip.position = marker_2d_2.position
	else:
		tool_tip.position = marker_2d.position
	canvas_layer.add_child(tool_tip)
