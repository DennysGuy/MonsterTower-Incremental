class_name TowerEntranceButton extends TextureButton

@export var tower_entrance_data : TowerEntranceData

const FLOOR_LOCKED_ICON = preload("uid://b7b4stfjjl7i3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_floor_data()
	if PlayerStats.check_points_unlocked[tower_entrance_data.floor_name]:
		texture_normal = tower_entrance_data.button_texture
	else:
		texture_normal = FLOOR_LOCKED_ICON


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	if !PlayerStats.check_points_unlocked[tower_entrance_data.floor_name]:
		return
	
	SignalBus.store_entrance_data.emit(tower_entrance_data)
	SignalBus.hide_hunt_time_label.emit()

func load_floor_data() -> void:
	if tower_entrance_data:
		var saved_data = SaveManager.current_save_game.tower_entrance_data
		var tower_data = saved_data.get(tower_entrance_data.floor_name)
		tower_entrance_data.camp_fires_reached = tower_data["Campfires Reached"]
		tower_entrance_data.number_of_spawn_locations = tower_data["Number of Spawn Locations"]
		tower_entrance_data.hunt_challenge_unlocked = tower_data["Hunt Challenge Unlocked"]
		tower_entrance_data.hunt_challenge_completed = tower_data["Hunt Challenge Completed"]


func _on_mouse_entered() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)

func _on_mouse_exited() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
