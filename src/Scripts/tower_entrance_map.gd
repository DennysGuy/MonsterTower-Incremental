class_name TowerEntranceMap extends Control

var stored_entrance_data : TowerEntranceData

@onready var biome_preview: TextureRect = $FloorDescriptionPanel/BiomePreview
@onready var floor_enemy_list: GridContainer = $FloorDescriptionPanel/FloorEnemyList
@onready var go_to_floor: Button = $FloorDescriptionPanel/GoToFloor

@onready var floor_title: Label = $FloorDescriptionPanel/FloorTitle
@onready var biome_title: Label = $FloorDescriptionPanel/BiomeTitle

@onready var time_limit: Label = $TimeLimit
@onready var area_button_selector: GridContainer = $FloorDescriptionPanel/AreaButtonSelector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.store_entrance_data.connect(store_entrance_data)
	time_limit.text = "Expedition Time Limit:\n%s Seconds" % [int(PlayerStats.player_stats["Expedition Time"])]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_go_to_floor_button_up() -> void:
	SignalBus.play_close_out_animation.emit()
	GameManager.player_can_move = true
	hide()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(stored_entrance_data.scene_path)

func store_entrance_data(entrance_data : TowerEntranceData) -> void:
	go_to_floor.disabled = false
	stored_entrance_data = entrance_data
	biome_preview.texture = entrance_data.preview_picture
	floor_title.text = "%s" % [entrance_data.floor_name]
	biome_title.text ="Biome: %s" % [entrance_data.biome]
	for child in area_button_selector.get_children():
		child.queue_free()
	
	for point in range(0,entrance_data.number_of_spawn_locations):
		var label : Label = Label.new()
		label.text = "Point %s" % [point]
		area_button_selector.add_child(label)
