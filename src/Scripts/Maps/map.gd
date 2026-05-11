class_name Map extends Node2D

@export var map_name : String
@export var map_id : int
@export var challenge_time_limit : int = 90
@export var exit_elevator_marker : Marker2D
@export var exit_elevator : ExitElevator
@export var tower_entrance_data : TowerEntranceData
@export var map_theme_song : AudioStream
@export var hunt_theme_song : AudioStream
@export var hunt_victory_theme : AudioStream
@export var spawn_point : Marker2D
@export var player_spawn : bool = true
@export var camera : PlayerCamera
@export var hud : PlayerHUD
@export var ore_rock_spawn_rate : float
@export var ore_rock_markers : Node
@export var gem_stone_chest_markers : Node
@export var campfire_list : Node
@export var hp_replenish_points : Node
@export var mp_replenish_points : Node

@export var path : String
@export var next_room_path : String
@export var sfx_player : SFXPlayer

@export var monster_spawn_node : Node
@export var pause_canvas_layer : CanvasLayer

@export var job_unlocks : Array[String]

enum MAP_TYPE {HUB, FLOOR, CHECKPOINT_FLOOR}

@export var map_type : MAP_TYPE = MAP_TYPE.HUB

var player : Player

@export var kill_quota : int = 0
@export var current_kill_count : int = 0

@export var ambience_player : AudioStreamPlayer
@export var ambience_sfx : AudioStream

const TIER_UP = preload("uid://dhfdudbiidv7a")



var kill_quota_hit : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !MusicPlayer.transitioning_floors:
		MusicPlayer.stop_player()
	GameManager.can_pause_game = true
	if tower_entrance_data:
		GameManager.previous_map_path = tower_entrance_data.scene_path
	else:
		GameManager.previous_map_path = path
	GameManager.previous_map_data = tower_entrance_data
	SignalBus.move_to_next_room.connect(move_to_next_room)
	SignalBus.return_to_starshire.connect(go_to_starshire)
	SignalBus.go_to_victory_hunt_menu.connect(go_to_victory_menu)
	SignalBus.go_to_failure_hunt_menu.connect(go_to_failure_menu)
	SignalBus.update_kill_quota.connect(update_hunt_quota)
	SignalBus.play_sfx.connect(play_sfx)
	LevelingManager.play_level_up_sfx.connect(play_level_up_sfx)
	#hud.map_name_label.text = map_name
	
	
	load_floor_data()
	
	if player_spawn:
		if map_type == MAP_TYPE.CHECKPOINT_FLOOR and tower_entrance_data.number_of_spawn_locations <= 0:
			tower_entrance_data.number_of_spawn_locations += 1
			SaveManager.save_floor_data(tower_entrance_data, map_name)
		
		if campfire_list:
			for i in range(0,tower_entrance_data.camp_fires_reached):
				var camp_fire = campfire_list.get_child(i)
				var checkpoint_campfire : CampFireCheckPoint = camp_fire
				checkpoint_campfire.unlocked = true
				checkpoint_campfire.animation_player.play("On")

		if map_type == MAP_TYPE.HUB and map_name == "Starspire - Hub":
			GameManager.spawn_location = 0
		
		
		spawn_player()
		
	
		if camera:
			camera.player = player
		
		if map_type == MAP_TYPE.CHECKPOINT_FLOOR:	
			GameManager.can_open_bag = true
			if !GameManager.hunt_challenge_selected:
				
				if tower_entrance_data.is_expedition_floor() and tower_entrance_data.unlock_recipe and !tower_entrance_data.hunt_challenge_completed:
					issue_repair_elevator_notice()
			
				elif tower_entrance_data.is_challenge_floor() and not tower_entrance_data.hunt_challenge_completed:
					issue_challenge_objective_notice()
				
				SignalBus.show_bag_stats.emit()
				
			if monster_spawn_node and GameManager.hunt_challenge_selected:
				PlayerHudSignalBus.update_monsters_left.emit("Monsters Left: %s" % [monster_spawn_node.get_children().size()],false)
				#else:
					#SignalBus.update_monsters_left.emit("Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires],false)
			
			
			PlayerStats.check_points_unlocked[map_name] = true
			SaveManager.save_floor_data(tower_entrance_data, map_name)
			SaveManager.save_player_stats()
		
		if map_type ==	MAP_TYPE.FLOOR or map_type == MAP_TYPE.CHECKPOINT_FLOOR:
				PlayerHudSignalBus.show_stop_watch.emit()
				if !GameManager.hunt_challenge_selected:
					GameManager.player_can_move = true
					if !tower_entrance_data.is_boss_door():
						PlayerHudSignalBus.start_stop_watch.emit()
				else:
					GameManager.player_can_move = false
					
	if map_type == MAP_TYPE.HUB:
		GameManager.hunt_challenge_selected = false
		
	if ambience_player and ambience_sfx:
		ambience_player.stream = ambience_sfx
		ambience_player.play()
	
	if !GameManager.hunt_challenge_selected:
		if map_theme_song:
			if !MusicPlayer.transitioning_floors:
				if !MusicPlayer.audio_stream_player.playing:
					MusicPlayer.play_song(map_theme_song)
			else:
				MusicPlayer.transitioning_floors = false
	else:
		if hunt_theme_song:
			MusicPlayer.play_song(hunt_theme_song)

func _input(event: InputEvent) -> void:
	pass

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("pause_game") and GameManager.can_pause_game:
		var pause_menu : PauseMenu = preload("uid://dlaq2oh2iuyjk").instantiate()
		pause_canvas_layer.show()
		pause_canvas_layer.add_child(pause_menu)

func spawn_player() -> void:
	var new_player : Player = preload("uid://wuy3aelq8aeg").instantiate()
	player = new_player
	var selected_spawn_point : PlayerSpawnPoint = choose_spawn_spoint()
	player.position = selected_spawn_point.position
	player.damageable = true
	var total_health : int = PlayerStats.player_stats["Current Health"]
	var total_mp : int = PlayerStats.player_stats["Current MP"]
	
	if GameManager.resupply_character:
		total_health = PlayerStats.player_stats["Max Health"] + PlayerStats.get_current_sword().get_total_hp_bonus()
		total_mp = PlayerStats.player_stats["Max MP"]  + PlayerStats.get_current_sword().get_total_defense_bonus()
		PlayerStats.player_stats["Current Health"] = total_health
		PlayerStats.player_stats["Current MP"] = total_mp
		player.health = total_health
		GameManager.resupply_character = false
		#PlayerHudSignalBus.update_player_health.emit()
		
	player.health = total_health
	print("THIS IS PLAYER HEALTH" + str(player.health))
	#hud.update_player_health(int(total_health))

	add_child(player)
	
func go_to_starshire() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.hunt_challenge_selected = false
	GameManager.expedition_timer_started = false
	GameManager.boss_door_challenge_active = false
	GameManager.can_issue_abilities = true
	GameManager.event_speed_mod = 1.0
	player.held_key = null
	var tree := get_tree()
	if tree == null:
		return
	
	PlayerHudSignalBus.play_close_out_animation.emit()
	await tree.create_timer(1.0).timeout

	if tree != null:
		if player.is_dead:
			tree.change_scene_to_file("uid://cq0un0c22235d")
		else:
			tree.change_scene_to_file("res://src/Scenes/UI/ExpeditionResultsScreen.tscn")

func go_to_victory_menu() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.hunt_challenge_selected = false
	GameManager.expedition_timer_started = false
	
	var tree := get_tree()
	if tree == null:
		return
	
	PlayerHudSignalBus.play_close_out_animation.emit()
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file("uid://c0iswrbu8opac")	

func go_to_failure_menu() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.hunt_challenge_selected = false
	GameManager.expedition_timer_started = false
	
	var tree := get_tree()
	if tree == null:
		return
	
	#hud.animation_player.play("CloseOut")
	PlayerHudSignalBus.play_close_out_animation.emit()
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file("uid://du5klyuwi6so2")	

func move_to_next_room(room_path : String) -> void:

	var tree := get_tree()
	if tree == null:
		return

	PlayerHudSignalBus.play_close_out_animation.emit()
	#hud.animation_player.play("CloseOut")
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file(room_path)

func roll_ore_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * ore_rock_spawn_rate)

func roll_gem_chest_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * PlayerStats.player_stats["Tier 1 Chest Spawn Rate"])

func roll_challice_spawn_chance() -> int :
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * PlayerStats.player_stats["Chalice Spawn Rate"])

func roll_vial_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * PlayerStats.player_stats["Vial Spawn Rate"])

func choose_spawn_spoint() -> PlayerSpawnPoint:
	var spawn_points : Array = get_tree().get_nodes_in_group("SpawnPoints")
	for spawn_local in spawn_points:
		if spawn_local.index == GameManager.spawn_location:
			return spawn_local
			
	return null

func spawn_ore_rocks() -> void:
	for ore_rock_marker in ore_rock_markers.get_children():
			if roll_ore_spawn_chance():
				ore_rock_marker.spawn_ore_rock()

func spawn_gem_chests() -> void:
	for gem_chest in gem_stone_chest_markers.get_children():
		if roll_gem_chest_spawn_chance():
			gem_chest.spawn_gem_chest()

func spawn_hp_chalices() -> void:
	for pos in hp_replenish_points.get_children():
		if roll_challice_spawn_chance():
			pos.spawn_hp_chalice()

func spawn_mp_vials() -> void:
	for pos in mp_replenish_points.get_children():
		if roll_challice_spawn_chance():
			pos.spawn_mp_vial()

func update_hunt_quota() -> void:
	if !GameManager.hunt_challenge_selected:
		return
	
	await get_tree().process_frame
	if map_type == MAP_TYPE.CHECKPOINT_FLOOR:
		if monster_spawn_node.get_children().is_empty():
			sfx_player.play_sfx(TIER_UP)
			MusicPlayer.stop_player()
			#MusicPlayer.play_song(hunt_victory_theme)
			GameManager.expedition_timer_started = false
			tower_entrance_data.hunt_challenge_completed = true
			SaveManager.save_floor_data(tower_entrance_data, map_name)
			play_unlock_elevator_sequence()
			SignalBus.unlock_next_room.emit()
			SignalBus.update_kill_quota_text.emit("Hunt Challenge Completed! Head to the Exit Elevator!", true, false)
			SignalBus.update_monsters_left.emit("Monsters Left: %s" % [monster_spawn_node.get_children().size()],false)
		else:
			SignalBus.update_kill_quota_text.emit("Defeat all Monsters to win!", false, false)	
			SignalBus.update_monsters_left.emit("Monsters Left: %s" % [monster_spawn_node.get_children().size()],false)


func load_floor_data() -> void:
	if tower_entrance_data:
		var saved_data = SaveManager.current_save_game.tower_entrance_data
		var tower_data = saved_data.get(tower_entrance_data.floor_name)

		tower_entrance_data.camp_fires_reached = tower_data["Campfires Reached"]
		tower_entrance_data.number_of_spawn_locations = tower_data["Number of Spawn Locations"]
		tower_entrance_data.hunt_challenge_unlocked = tower_data["Hunt Challenge Unlocked"]
		tower_entrance_data.hunt_challenge_completed = tower_data["Hunt Challenge Completed"]
		
		if tower_entrance_data.floor_number > PlayerStats.player_stats["Highest Floor"]:
			PlayerStats.player_stats["Highest Floor"] = tower_entrance_data.floor_number
			SaveManager.save_player_stats()
		if exit_elevator:
			exit_elevator.current_room_data = tower_entrance_data

func play_sfx(audio_stream : AudioStream) -> void:
	if sfx_player:
		sfx_player.play_sfx(audio_stream)

func play_level_up_sfx() -> void:
	if sfx_player:
		sfx_player.play_sfx(TIER_UP)


func issue_repair_elevator_notice() -> void:
	camera.player = null
	GameManager.player_can_move = false
	GameManager.can_pause_game = false
	GameManager.can_open_bag = false
	GameManager.enemies_can_move = false

	player.send_to_idle_state()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = exit_elevator_marker.position
	await get_tree().create_timer(1.0).timeout
	PlayerHudSignalBus.issue_big_notification.emit("Deliver required resource to repair the elevator!")
	await get_tree().create_timer(3.0).timeout
	PlayerHudSignalBus.hide_big_notification.emit()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = player.position
	camera.player = player
	
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.enemies_can_move = true

func issue_challenge_objective_notice() -> void:
	camera.player = null
	GameManager.player_can_move = false
	GameManager.can_pause_game = false
	GameManager.can_open_bag = false
	GameManager.enemies_can_move = false

	player.send_to_idle_state()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	camera.position = exit_elevator_marker.position
	await get_tree().create_timer(1.0).timeout
	PlayerHudSignalBus.issue_big_notification.emit("Beat the Floor Challenge to unlock the exit elevator!")
	await get_tree().create_timer(3.0).timeout
	SignalBus.hide_big_notification.emit()
	#hud.animation_player.play("FadeInOut")
	await get_tree().create_timer(0.5).timeout
	PlayerHudSignalBus.hide_big_notification.emit()
	camera.position = player.position
	camera.player = player
	
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.enemies_can_move = true

func play_unlock_elevator_sequence() -> void:
	GameManager.can_pause_game = false
	GameManager.can_open_bag = false
	GameManager.enemies_can_move = false
	camera.player = null

	player.send_to_idle_state()
	GameManager.player_can_move = false
	camera.position = exit_elevator_marker.position
	await get_tree().create_timer(1.0).timeout
	exit_elevator.unlock_elevator()
	await get_tree().create_timer(5.0).timeout
	sfx_player.play_sfx(hunt_victory_theme)
	PlayerHudSignalBus.issue_big_notification.emit("Challenge Overcome!\nHead to the Elevator!")
	await get_tree().create_timer(2.0).timeout
	camera.position = player.position
	camera.player = player
	
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.enemies_can_move = true

func unlock_quests() -> void:
	var unlocked_a_job : bool = false
	for quest_name in job_unlocks:
		var quest : Quest = QuestManager.get_quest(quest_name)
		if quest.is_locked():
			quest.set_as_available()
			unlocked_a_job = true
	
	if unlocked_a_job:
		GameManager.new_jobs_available = true
		SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.QUEST)
		
