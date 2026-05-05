class_name Biome1Floor2 extends Map

var player_in_exit_area : bool = false
@onready var guide_log: Label = $GuideLog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#hud.animation_player.play("CloseIn")
	SignalBus.spawn_enemies.emit()
	
	if ore_rock_markers and !GameManager.hunt_challenge_selected:
		spawn_ore_rocks()
	
	if gem_stone_chest_markers and !GameManager.hunt_challenge_selected and PlayerStats.facilities_unlocked["Gem Stone Station"]:
		spawn_gem_chests()
	
	if hp_replenish_points and PlayerStats.facilities_unlocked["HP Chalice"] and !GameManager.hunt_challenge_selected:
		spawn_hp_chalices()
	
	if mp_replenish_points and PlayerStats.facilities_unlocked["MP Vial"] and !GameManager.hunt_challenge_selected:
		spawn_mp_vials()
	
	await get_tree().process_frame
	
	if monster_spawn_node:
		if GameManager.hunt_challenge_selected:
			#hud.animation_player.play("StartHuntChallnge")
			SignalBus.update_monsters_left.emit("Monsters left: %s" % [monster_spawn_node.get_children()],false,false)
		else:
			SignalBus.update_monsters_left.emit("Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires],false)
	
	QuestManager.check_map_name.emit(map_name)
	SignalBus.update_banner_info.emit(tower_entrance_data)
	PlayerHudSignalBus.update_player_health.emit()
	PlayerHudSignalBus.update_player_mp.emit()
	SaveManager.save_player_stats()
	PlayerHudSignalBus.show_stop_watch.emit()
	if GameManager.hunt_challenge_selected:
		GameManager.enemies_can_move = false
		SignalBus.hide_hunt_challenge_button.emit()
		var monster_count : int = monster_spawn_node.get_children().size()
		SignalBus.update_monsters_left.emit("Monsters left: %s" % [monster_count])
		player.damageable = false
		await get_tree().create_timer(0.5).tidmeout
		#hud.set_hunt_timer()
		#hud.expedition_timer.update_timer_label()
		#hud.animation_player.play("StartHuntChallenge")
		await get_tree().create_timer(4.0).timeout
		player.damageable = true
		GameManager.player_can_move = true
	else:
		SignalBus.start_enemy_spawn.emit()
		PlayerHudSignalBus.start_stop_watch.emit()
	
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("interact") and player_in_exit_area and player.damageable:
		go_to_starshire()

func _on_tower_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_exit_area = true
		guide_log.show()

func _on_tower_exit_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_exit_area = true
		guide_log.hide()
