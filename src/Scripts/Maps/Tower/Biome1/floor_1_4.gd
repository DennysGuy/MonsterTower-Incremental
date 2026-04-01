class_name Biome1Floor4 extends Map


func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	#checkpoint_campfire.play("default")
	SignalBus.spawn_enemies.emit()
	
	if ore_rock_markers and !GameManager.hunt_challenge_selected:
		spawn_ore_rocks()
	
	if gem_stone_chest_markers and !GameManager.hunt_challenge_selected and PlayerStats.facilities_unlocked["Gem Stone Station"]:
		spawn_gem_chests()
		
	await get_tree().process_frame
	
	if monster_spawn_node:
		if GameManager.hunt_challenge_selected:
			hud.animation_player.play("StartHuntChallnge")
			SignalBus.update_monsters_left.emit("Defeat all Monsters to win!",false,false)
		else:
			SignalBus.update_monsters_left.emit("Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires],false)
	SignalBus.update_player_health.emit(player.health)
	SignalBus.update_player_mp.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	#if Input.is_action_just_pressed("interact") and in_check_point_area:
		#go_to_starshire()
