class_name BeginnerTechTree extends Node2D

@onready var class_selection_node: ClassSelectionNode = $ClassSelectionNode
@onready var available_ap_label: Label = $CanvasLayer/AvailableAPLabel
@onready var marker_2d: Marker2D = $CanvasLayer/Marker2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.check_if_can_show_class_select_node.connect(check_to_unveil_class_selection_node)
	TechTreeManager.update_available_ap_label.connect(update_ap_available)
	TechTreeManager.add_tool_tip.connect(add_tool_tip)
	update_ap_available()
	check_to_unveil_class_selection_node()
	camera_2d.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()


func check_to_unveil_class_selection_node() -> void:
	if PlayerStats.facilities_unlocked["Arial Slash"] and PlayerStats.facilities_unlocked["Dash"] and PlayerStats.facilities_unlocked["Double Jump"]:
		QuestManager.check_general_task_for_completion.emit("Unlock All Base Abilities")
		class_selection_node.show()


func close_out() -> void:
	
	TechTreeManager.set_ability_hud_icon.emit()
	CutsceneManager.enable_player_functionality()
	SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.AP)
	SignalBus.combat_class_menu_closed.emit()
	
	PlayerHudSignalBus.hub_menu_exited.emit()
	await get_tree().create_timer(0.3).timeout
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func update_ap_available() -> void:
	available_ap_label.text = "Available AP: %s" % [PlayerStats.player_stats["Ability Points"]]

func add_tool_tip(tool_tip : ToolTip, on_right_hand : bool) -> void:
	tool_tip.position = marker_2d.position
	canvas_layer.add_child(tool_tip)


func _on_exit_button_button_up() -> void:
	close_out()
