class_name MossyDungeonBossMap extends Map


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	
	
	await get_tree().process_frame
	SignalBus.update_banner_info.emit(tower_entrance_data)
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	PlayerHudSignalBus.show_boss_hp_bar.emit()
	ExpeditionTimer.set_time_for_door_challenge(120)
	PlayerHudSignalBus.show_stop_watch.emit()
	PlayerHudSignalBus.load_timer_label.emit()
	PlayerHudSignalBus.start_stop_watch.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
