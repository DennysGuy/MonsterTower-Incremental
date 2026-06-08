class_name TowerEntranceMap extends Control

var stored_entrance_data : TowerEntranceData

@onready var biome_preview: TextureRect = $FloorDescriptionPanel/BiomePreview
@onready var floor_enemy_list: GridContainer = $FloorDescriptionPanel/FloorEnemyList
@onready var go_to_floor: Button = $ModeDescription/GoToFloor

@onready var floor_title: Label = $FloorDescriptionPanel/FloorTitle
@onready var biome_title: Label = $FloorDescriptionPanel/BiomeTitle

@onready var time_limit: Label = $TimeLimit
@onready var area_button_selector: GridContainer = $FloorDescriptionPanel/AreaButtonSelector

@onready var hunt_time_label: Label = $FloorDescriptionPanel/HuntTimeLabel

@onready var hunt_selection: Button = $FloorDescriptionPanel/HuntSelection
@onready var mode_description_label: RichTextLabel = $ModeDescription/ModeDescriptionLabel

@onready var hunt_notification: Control = $FloorDescriptionPanel/HuntNotification
@onready var selected_point: Label = $SelectedPoint
@onready var drops_preview_panel: Control = $ModeDescription/DropsPreviewPanel

@onready var enemies_preview_grid_container: GridContainer = $ModeDescription/DropsPreviewPanel/PanelContainer/EnemiesPreviewGridContainer
@onready var ore_preview_grid_container: GridContainer = $ModeDescription/DropsPreviewPanel/PanelContainer2/OrePreviewGridContainer
@onready var music_player: AudioStreamPlayer = $MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.pause_music()
	music_player.play()
	SignalBus.store_entrance_data.connect(store_entrance_data)
	SignalBus.update_entrance_map.connect(update_entrance_map)
	SignalBus.update_mode_description_to_expedition.connect(set_mode_description_as_expedition)
	SignalBus.hide_hunt_time_label.connect(hide_hunt_time_label)
	time_limit.text = "Expedition Time Limit: %s Seconds" % [int(PlayerStats.player_stats["Expedition Time"])]
	hunt_time_label.hide()
	
	drops_preview_panel.hide()
	load_most_recent_floor()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_go_to_floor_button_up() -> void:
	PlayerHudSignalBus.play_close_out_animation.emit()
	GameManager.player_can_move = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	GameManager.resupply_character = true
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.move_inventory_to_bank()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(stored_entrance_data.scene_path)

func store_entrance_data(entrance_data : TowerEntranceData) -> void:
	GameManager.spawn_location = 0
	set_mode_description_as_expedition()
	go_to_floor.disabled = false
	stored_entrance_data = entrance_data
	if !entrance_data.preview_pictures.is_empty():
		biome_preview.texture = entrance_data.preview_pictures[0]
	floor_title.text = "%s" % [entrance_data.floor_name]
	biome_title.text ="Biome: %s" % [entrance_data.biome]
	selected_point.text = "Selected Point: %s - %s - Point: %s" % [entrance_data.biome, entrance_data.floor_name, GameManager.spawn_location+1]
	hunt_time_label.text = "Hunt Challenge Time Limit: %s seconds" % [stored_entrance_data.hunt_challenge_time]
	for child in area_button_selector.get_children():
		child.queue_free()
	
	for point in range(0,entrance_data.number_of_spawn_locations):
		var check_point_button : CheckPointButton = preload("uid://bpikj7ilsaiqj").instantiate()
		check_point_button.text = "Checkpoint %s" % [point+1]
		check_point_button.index = point
		area_button_selector.add_child(check_point_button)
	
	if entrance_data.is_challenge_floor() and entrance_data.hunt_challenge_unlocked:
		hunt_selection.show()
	else:
		hunt_selection.hide()
	
	if entrance_data.is_challenge_floor() and !entrance_data.hunt_challenge_completed and entrance_data.hunt_challenge_unlocked:
		hunt_notification.show()
	else:
		hunt_notification.hide()
	
	populate_preview_container(enemies_preview_grid_container, stored_entrance_data.enemy_preview_graphics)
	populate_preview_container(ore_preview_grid_container, stored_entrance_data.ore_rock_preview_graphics)

func _on_close_button_up() -> void:
	CutsceneManager.enable_player_functionality()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	music_player.stop()
	MusicPlayer.unpause_music()
	queue_free()
	
func update_entrance_map(index : int) -> void:
	biome_preview.texture = stored_entrance_data.preview_pictures[index]
	GameManager.spawn_location = index
	selected_point.text = "Selected Point: %s - %s - Point: %s" % [stored_entrance_data.biome, stored_entrance_data.floor_name, GameManager.spawn_location+1]
	
func _on_hunt_selection_button_up() -> void:
	set_mode_description_as_hunt_challenge()
	GameManager.spawn_location = 0
	GameManager.hunt_challenge_selected = true
	selected_point.text = "Selected Point: %s - %s - Hunt Point" % [stored_entrance_data.biome, stored_entrance_data.floor_name]
	show_hunt_time_label()
	
func show_hunt_time_label() -> void:
	hunt_time_label.show()

func hide_hunt_time_label() -> void:
	hunt_time_label.hide()

func set_mode_description_as_expedition() -> void:
	mode_description_label.text = "	   ~Expedition~ 
	
Hunt, Train, Explore within you Hunter Class time limit!
	
	"
	drops_preview_panel.show()

func set_mode_description_as_hunt_challenge() -> void:
	drops_preview_panel.hide()
	mode_description_label.text = "	 ~Hunt Challenge~

Test your skills. 
Race against the clock to meet the [color=green]hunt quota[/color] to unlock the [color=green]next floor[/color]. 
No Drops, no Resources - just [color=red]pure combat[/color]!"

func populate_preview_container(preview_container : GridContainer, GraphicsArray : Array[Texture2D] ) -> void:
	InventoryManager.clear_grid_container(preview_container)
	for graphic in GraphicsArray:
		var texture : PreviewIconGraphic = preload("uid://c53idabyvvlhs").instantiate()
		texture.texture = graphic
		preview_container.add_child(texture)

func load_most_recent_floor() -> void:
	for floor_button in get_tree().get_nodes_in_group("FloorEntranceButton"):
		if floor_button.tower_entrance_data.floor_number == PlayerStats.player_stats["Highest Floor"]:
			store_entrance_data(floor_button.tower_entrance_data)
			return
