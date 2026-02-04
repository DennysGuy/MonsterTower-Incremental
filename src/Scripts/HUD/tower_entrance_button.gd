class_name TowerEntranceButton extends TextureButton

@export var tower_entrance_data : TowerEntranceData
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_floor_data()
	animation_player.play("LockOnBlink")
	if PlayerStats.check_points_unlocked[tower_entrance_data.floor_name]:
		show()
	else:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	SignalBus.store_entrance_data.emit(tower_entrance_data)

func load_floor_data() -> void:
	if tower_entrance_data:
		var saved_data = SaveManager.current_save_game.tower_entrance_data
		var tower_data = saved_data.get(tower_entrance_data.floor_name)
		tower_entrance_data.camp_fires_reached = tower_data["Campfires Reached"]
		tower_entrance_data.number_of_spawn_locations = tower_data["Number of Spawn Locations"]
		tower_entrance_data.kill_quota_hit = tower_data["Kill Quota Hit"]
