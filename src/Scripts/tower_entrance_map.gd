class_name TowerEntranceMap extends Control

var stored_entrance_data : TowerEntranceData

@onready var biome_preview: TextureRect = $FloorDescriptionPanel/BiomePreview
@onready var floor_enemy_list: GridContainer = $FloorDescriptionPanel/FloorEnemyList
@onready var go_to_floor: Button = $FloorDescriptionPanel/GoToFloor

@onready var floor_title: Label = $FloorDescriptionPanel/FloorTitle
@onready var biome_title: Label = $FloorDescriptionPanel/BiomeTitle

@onready var time_limit: Label = $TimeLimit
@onready var area_button_selector: GridContainer = $FloorDescriptionPanel/AreaButtonSelector
@onready var hunt_challenge_notification: Label = $FloorDescriptionPanel/HuntChallengeNotification

@onready var hunt_selection: Button = $FloorDescriptionPanel/HuntSelection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.store_entrance_data.connect(store_entrance_data)
	SignalBus.update_entrance_map.connect(update_entrance_map)
	time_limit.text = "Expedition Time Limit:\n%s Seconds" % [int(PlayerStats.player_stats["Expedition Time"])]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_go_to_floor_button_up() -> void:
	SignalBus.play_close_out_animation.emit()
	GameManager.player_can_move = true
	GameManager.resupply_character = true
	hide()
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.move_inventory_to_bank()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(stored_entrance_data.scene_path)

func store_entrance_data(entrance_data : TowerEntranceData) -> void:
	GameManager.spawn_location = 0
	go_to_floor.disabled = false
	stored_entrance_data = entrance_data
	biome_preview.texture = entrance_data.preview_pictures[0]
	floor_title.text = "%s" % [entrance_data.floor_name]
	biome_title.text ="Biome: %s" % [entrance_data.biome]
	
	for child in area_button_selector.get_children():
		child.queue_free()
	
	for point in range(0,entrance_data.number_of_spawn_locations):
		var check_point_button : CheckPointButton = preload("uid://bpikj7ilsaiqj").instantiate()
		check_point_button.text = "Point %s" % [point+1]
		check_point_button.index = point
		area_button_selector.add_child(check_point_button)
	
	hunt_selection.disabled = false


func _on_close_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()

func update_entrance_map(index : int) -> void:
	biome_preview.texture = stored_entrance_data.preview_pictures[index]
	GameManager.spawn_location = index

func _on_hunt_selection_button_up() -> void:
	hunt_challenge_notification.show()
	GameManager.hunt_challenge_selected = true
