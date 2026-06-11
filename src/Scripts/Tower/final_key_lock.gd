class_name FinalKeyLock extends BossKeyLock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	notice.show()
	if body is Player:
		player = body
		if body.held_key and body.held_key.key_type == body.held_key.KEY_TYPE.FINAL:
			correct_key_detected = true
			notice.text = "Press 'E' to insert key!"
		else:
			correct_key_detected = false
			notice.text = "Requires the Boss Key."


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		correct_key_detected = false
		notice.hide()


func _on_enable_zone_area_entered(area: Area2D) -> void:
	var parent = area.get_parent() 
	if parent is BossDoorKey and !parent.can_pick_up:
		play_sfx(MOUNT_ABILITY)
		await get_tree().process_frame
		play_sfx(RETRO_WEIRD_07,-4)
		
		set_lock_filled()
		ExpeditionTimer.stop_timer()
		GameManager.boss_door_challenge_active = false
		SignalBus.set_combat_ability_icon_enabled.emit()
		MusicPlayer.stop_player()
		parent.queue_free()
		SignalBus.shake_camera.emit(3.0)
		await get_tree().create_timer(3.0).timeout
		SignalBus.unlock_boss_door.emit()
