class_name Biome1Floor3 extends Map

var in_check_point_area : bool = false
@onready var checkpoint_log: Label = $CheckpointLog
#@onready var checkpoint_campfire: AnimatedSprite2D = $CheckpointCampfire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#hud.animation_player.play("CloseIn")
	#checkpoint_campfire.play("default")
	SignalBus.start_enemy_spawn.emit()
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
	
	QuestManager.check_map_name.emit(tower_entrance_data.floor_name)
	unlock_quests()
	PlayerHudSignalBus.show_stop_watch.emit()

	if GameManager.hunt_challenge_selected:
		hud.animation_player.play("StartHuntChallnge")
		SignalBus.update_monsters_left.emit("Defeat all Monsters to win!",false,false)
	else:
		SignalBus.update_monsters_left.emit("Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires],false)
		PlayerHudSignalBus.start_stop_watch.emit()
	
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	SignalBus.update_banner_info.emit(tower_entrance_data)
	PlayerHudSignalBus.update_player_health.emit()
	PlayerHudSignalBus.update_player_mp.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("interact") and in_check_point_area:
		go_to_starshire()

func _on_checkpoint_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = true
		checkpoint_log.show()

func _on_checkpoint_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = false
		checkpoint_log.hide()
