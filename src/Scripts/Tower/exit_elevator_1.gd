class_name ExitElevator extends Node2D

@export var next_room : PackedScene
@export var next_room_data : TowerEntranceData
@export var current_room_data : TowerEntranceData
var player_in_range : bool = false
var needed_quota_met : bool = false
var doors_open : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_to_next_room_label: Label = $MoveToNextRoomLabel
@onready var needed_panel: Panel = $NeededPanel

const BROKEN_FLOOR_ELEVATOR_BASE = preload("uid://bq5k4w7uwsgyy")
const FLOOR_ELEVATOR_BASE = preload("uid://sm0sjtn0eenp")
const ABILITY_ROW_UNLOCKED = preload("uid://joo0a5xuf1pm")

@onready var row_lock: Sprite2D = $RowLock


@onready var needed_items_container: GridContainer = $NeededPanel/NeededItemsContainer

@onready var base: Sprite2D = $Base

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.unlock_next_room.connect(unlock_next_room)
	
	if current_room_data.unlock_recipe and current_room_data.is_expedition_floor():
		if !current_room_data.hunt_challenge_completed:
			base.texture = BROKEN_FLOOR_ELEVATOR_BASE
			populate_items_needed_list()
		else:
			base.texture = FLOOR_ELEVATOR_BASE
	else:
		base.texture = FLOOR_ELEVATOR_BASE
	
	if !current_room_data.hunt_challenge_completed and current_room_data.is_challenge_floor():
		row_lock.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		if GameManager.hunt_challenge_selected:
			unlock_next_floor()
			SignalBus.go_to_victory_hunt_menu.emit()
		else:
			if current_room_data.hunt_challenge_completed or (current_room_data.is_expedition_floor() and !current_room_data.unlock_recipe):
				MusicPlayer.transitioning_floors = true
				GameManager.spawn_location = 0
				SignalBus.move_to_next_room.emit(next_room_data.scene_path)
			else:
				unlock_next_room()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		var deliver_quantity : int = 0
		if current_room_data.unlock_recipe:
			deliver_quantity = InventoryManager.calculate_quantity(current_room_data.unlock_recipe)
		
		if current_room_data.hunt_challenge_completed or current_room_data.is_expedition_floor() and !current_room_data.unlock_recipe:
			move_to_next_room_label.text = "Press 'E' to advance to next floor!"
			doors_open = true
			animation_player.play("DoorsOpen")
		else:
			if current_room_data.is_challenge_floor():
				move_to_next_room_label.text = "Beat the Floor Challenge to Unlock Elevator!"
			if current_room_data.is_expedition_floor() and deliver_quantity >= 1:
				move_to_next_room_label.text = "Press 'E' to repair the Elevator!"
		
		move_to_next_room_label.show()
		
func unlock_next_room() -> void:
	if current_room_data.is_expedition_floor():
		if InventoryManager.calculate_quantity(current_room_data.unlock_recipe) < 1:
			return
			
		if current_room_data.unlock_recipe:
			InventoryManager.remove_resources_from_inventory(current_room_data.unlock_recipe.recipe_list)
			
		needed_panel.hide()
		base.texture = FLOOR_ELEVATOR_BASE
		GameManager.spawn_location = 0
		current_room_data.hunt_challenge_completed = true
		SaveManager.save_floor_data(current_room_data, current_room_data.floor_name)
		animation_player.play("DoorsOpen")
		await get_tree().create_timer(1.0).timeout
		SignalBus.move_to_next_room.emit(next_room_data.scene_path)
		
	#needed_quota_met = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range =false
		move_to_next_room_label.hide()
		if doors_open:
			animation_player.play("DoorsClose")
			doors_open = false

func unlock_next_floor() -> void:
	PlayerStats.check_points_unlocked[next_room_data.floor_name] = true
	save_next_floor_data()

func save_next_floor_data() -> void:
	var saved_data = SaveManager.current_save_game
	saved_data.tower_entrance_data[next_room_data.floor_name]["Number of Spawn Locations"] = next_room_data.number_of_spawn_locations
	saved_data.check_points_unlocked[next_room_data.floor_name] = PlayerStats.check_points_unlocked[next_room_data.floor_name] 
	SaveManager.save_game()

func populate_items_needed_list() -> void:
	needed_panel.show()
	InventoryManager.clear_grid_container(needed_items_container)
	for item_dict in current_room_data.unlock_recipe.recipe_list:
		for item in item_dict.keys():
			var quantity_list_item : QuantityListItem = preload("uid://cq8n5gyropdxm").instantiate()
			quantity_list_item.icon.texture = item.shop_icon
			quantity_list_item.quantity_label.text = "x%s" % [item_dict[item]]
			needed_items_container.add_child(quantity_list_item)

func unlock_elevator() -> void:
	animation_player.play("UnlockElevator")
	SignalBus.flash_screen.emit()
	await get_tree().create_timer(0.5).timeout
	row_lock.hide()
	
func play_unlock_sfx() -> void:
	play_sfx(ABILITY_ROW_UNLOCKED)



func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
