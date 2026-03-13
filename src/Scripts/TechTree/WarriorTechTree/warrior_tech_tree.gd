class_name WarriorTechTree extends Control

@onready var node_row_v_box: VBoxContainer = $NodeRowVBox
@onready var camera_2d: Camera2D = $Camera2D

var selected_row_index = 6

@onready var ap_label: Label = $CanvasLayer/APLabel

# Called when the node enters the scense tree for the first time.
func _ready() -> void:
	LevelingManager.update_available_ap_label.connect(update_ap_label)
	update_ap_label()
	node_row_v_box.get_child(selected_row_index).show_arrows()
	camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("pan_cam_up") and selected_row_index > 0:
		node_row_v_box.get_child(selected_row_index).hide_arrows()
		selected_row_index -= 1
		node_row_v_box.get_child(selected_row_index).show_arrows()
	
	
	if Input.is_action_just_pressed("pan_cam_down") and selected_row_index < node_row_v_box.get_children().size()-1:
		node_row_v_box.get_child(selected_row_index).hide_arrows()
		selected_row_index += 1
		node_row_v_box.get_child(selected_row_index).show_arrows()

	camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position

func _on_button_button_up() -> void:
	close_out()

func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func update_ap_label() -> void:
	ap_label.text = "AP Available: %s " % PlayerStats.player_stats["Ability Points"]
