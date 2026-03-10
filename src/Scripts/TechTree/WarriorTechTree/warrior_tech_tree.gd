class_name WarriorTechTree extends Control

@onready var node_row_v_box: VBoxContainer = $NodeRowVBox
@onready var camera_2d: Camera2D = $Camera2D

var selected_row_index = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pan_cam_up") and selected_row_index > 0:
		selected_row_index -= 1
		camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position
	
	if Input.is_action_just_pressed("pan_cam_down") and selected_row_index < node_row_v_box.get_children().size()-1:
		selected_row_index += 1
		camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position
