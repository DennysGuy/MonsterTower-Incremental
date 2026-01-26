class_name TechTree extends Node2D

@onready var currency: Label = $CanvasLayer/Currency
@onready var presitge_tier: Label = $CanvasLayer/PresitgeTier
@onready var prestige_progress: Label = $CanvasLayer/PrestigeProgress
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var marker_2d: Marker2D = $CanvasLayer/Marker2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var sfx_player: SFXPlayer = $SfxPlayer

const CLOSE_UPGRADE_PC = preload("uid://ckgce5whd3hq7")
const OPEN_UPGRADE_PC = preload("uid://coaqdaythm28l")


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
		update_currency_label()
		TechTreeManager.check_if_can_purchase_node.emit()

func update_currency_label() -> void:
	currency.text = "Currency: %s" % [TechTreeManager.currency]

func update_prestige_label() -> void:
	presitge_tier.text = "Prestige: %s" % [TechTreeManager.current_prestige]

func update_prestige_progress() -> void:
	prestige_progress.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
	progress_bar.max_value = TechTreeManager.upgrade_count_to_prestige
	progress_bar.value = TechTreeManager.current_upgrade_count
	
func _enter_tree() -> void:
	GameManager.player_can_move = false

func _exit_tree() -> void:
	GameManager.player_can_move = true

func _on_close_button_down() -> void:
	if PlayerStats.show_cooking_station_unlock_animation:
		TechTreeManager.unlock_cooking_station.emit()
		PlayerStats.show_cooking_station_unlock_animation = false
	
	if PlayerStats.show_refinery_station_unlock_animation:
		TechTreeManager.unlock_refinery.emit()
		PlayerStats.show_refinery_station_unlock_animation = false
	
	sfx_player.play_sfx(CLOSE_UPGRADE_PC)
	queue_free()

func add_tool_tip(tool_tip : ToolTip) -> void:
	tool_tip.position = marker_2d.position
	canvas_layer.add_child(tool_tip)
