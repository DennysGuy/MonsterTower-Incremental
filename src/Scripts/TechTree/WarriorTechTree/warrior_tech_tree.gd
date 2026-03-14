class_name WarriorTechTree extends Control

@onready var node_row_v_box: VBoxContainer = $NodeRowVBox
@onready var camera_2d: Camera2D = $Camera2D
var can_move_camera : bool = true
var selected_row_index = 6
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ap_label: Label = $CanvasLayer/APLabel
const MOVE_CLASS_TREE_CAMERA = preload("uid://d0vikx62lmfe7")

# Called when the node enters the scense tree for the first time.
func _ready() -> void:
	LevelingManager.update_available_ap_label.connect(update_ap_label)
	update_ap_label()
	check_for_unlocked_rows()
	check_for_newly_unlocked_rows()
	node_row_v_box.get_child(selected_row_index).show_arrows()
	camera_2d.global_position = node_row_v_box.get_child(selected_row_index).focus_marker.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("pan_cam_up") and selected_row_index > 0 and can_move_camera:
		node_row_v_box.get_child(selected_row_index).hide_arrows()
		selected_row_index -= 1
		play_sfx(MOVE_CLASS_TREE_CAMERA)
		node_row_v_box.get_child(selected_row_index).show_arrows()
	
	
	if Input.is_action_just_pressed("pan_cam_down") and selected_row_index < node_row_v_box.get_children().size()-1 and can_move_camera:
		node_row_v_box.get_child(selected_row_index).hide_arrows()
		selected_row_index += 1
		play_sfx(MOVE_CLASS_TREE_CAMERA)
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


func unlock_ability_node_row(index : int) -> void:
	can_move_camera = false
	selected_row_index = index
	var ability_row : AbilityTreeNodeRow = node_row_v_box.get_child(index)
	camera_2d.global_position = ability_row.global_position
	await get_tree().create_timer(0.5).timeout
	if ability_row.ability_row_lock:
		ability_row.play_lock_break_animation()
	await get_tree().create_timer(2.0).timeout
	animation_player.play("ScreenFlash")
	await get_tree().create_timer(0.25).timeout
	ability_row.ability_row_lock.queue_free()
	ability_row.enable_guide_arrow()
	ability_row.is_unlocked = true
	SaveManager.current_save_game.class_ability_rows["Tyro"][ability_row.unlock_level] = true
	SaveManager.save_game()
	
	await get_tree().create_timer(1.0).timeout
	can_move_camera = true


func check_for_unlocked_rows() -> void:
	for row in node_row_v_box.get_children():
		if row.is_unlocked:
			
			row.ability_row_lock.queue_free()
			row.enable_guide_arrow()

func check_for_newly_unlocked_rows() -> void:
	for index in range(node_row_v_box.get_children().size()-1,-1,-1):
		if node_row_v_box.get_child(index).is_unlocked:
			selected_row_index = index
		
		elif PlayerStats.player_stats["Level"] >= node_row_v_box.get_child(index).unlock_level and !node_row_v_box.get_child(index).is_unlocked:
			await unlock_ability_node_row(index)


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
