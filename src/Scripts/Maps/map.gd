class_name Map extends Node2D

@export var map_name : String
@export var map_id : int
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

@export var path : String
@export var next_room_path : String
@export var sfx_player : SFXPlayer

@export var monster_spawn_node : Node
@export var pause_canvas_layer : CanvasLayer

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
	GameManager.can_pause_game = true
	GameManager.previous_map_path = path
	GameManager.previous_map_data = tower_entrance_data
	SignalBus.move_to_next_room.connect(move_to_next_room)
	SignalBus.return_to_starshire.connect(go_to_starshire)
	SignalBus.go_to_victory_hunt_menu.connect(go_to_victory_menu)
	SignalBus.go_to_failure_hunt_menu.connect(go_to_failure_menu)
	SignalBus.update_kill_quota.connect(update_hunt_quota)
	SignalBus.play_sfx.connect(play_sfx)
	LevelingManager.play_level_up_sfx.connect(play_level_up_sfx)
	hud.map_name_label.text = map_name
	
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
		
		if hud:
			hud.show()
		
		spawn_player()
	
		if camera:
			camera.player = player
		
		if map_type == MAP_TYPE.CHECKPOINT_FLOOR:	
			hud.expedition_timer.show_stop_watch()
			if !GameManager.hunt_challenge_selected:
				if tower_entrance_data.hunt_challenge_completed:
					SignalBus.unlock_next_room.emit()
					#SignalBus.update_kill_quota_text.emit("", tower_entrance_data.hunt_challenge_completed, tower_entrance_data.hunt_challenge_unlocked)
				#else:
					##SignalBus.update_kill_quota_text.emit("", false, tower_entrance_data.hunt_challenge_unlocked)
					#if tower_entrance_data.hunt_challenge_unlocked and !tower_entrance_data.hunt_challenge_completed:
						#SignalBus.show_hunt_challenge_button.emit()
					#else:
						#SignalBus.hide_hunt_challenge_button.emit()
				SignalBus.show_bag_stats.emit()
					#
			#if monster_spawn_node:
				#if GameManager.hunt_challenge_selected:
					#SignalBus.update_monsters_left.emit("Monsters Left: %s" % [monster_spawn_node.get_children().size()],false)
				#else:
					#SignalBus.update_monsters_left.emit("Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires],false)
			SignalBus.update_banner_info.emit(tower_entrance_data)
			PlayerStats.check_points_unlocked[map_name] = true
			SaveManager.save_floor_data(tower_entrance_data, map_name)
			SaveManager.save_player_stats()
		
		if map_type ==	MAP_TYPE.FLOOR or map_type == MAP_TYPE.CHECKPOINT_FLOOR:
				if !GameManager.hunt_challenge_selected:
					GameManager.player_can_move = true
					hud.start_expedition_timer()
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
		
	player.health = total_health
	hud.update_player_health(int(total_health))

	add_child(player)
	
func go_to_starshire() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.hunt_challenge_selected = false
	GameManager.expedition_timer_started = false
	
	var tree := get_tree()
	if tree == null:
		return
	
	hud.animation_player.play("CloseOut")
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file("res://src/Scenes/UI/ExpeditionResultsScreen.tscn")

func go_to_victory_menu() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.hunt_challenge_selected = false
	GameManager.expedition_timer_started = false
	
	var tree := get_tree()
	if tree == null:
		return
	
	hud.animation_player.play("CloseOut")
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
	
	hud.animation_player.play("CloseOut")
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file("uid://du5klyuwi6so2")	

func move_to_next_room(room_path : String) -> void:
	if not next_room_path:
		return

	var tree := get_tree()
	if tree == null:
		return

	hud.animation_player.play("CloseOut")
	await tree.create_timer(1.0).timeout

	if tree != null:
		tree.change_scene_to_file(room_path)

func roll_ore_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * ore_rock_spawn_rate)

func roll_gem_chest_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * PlayerStats.player_stats["Tier 1 Chest Spawn Rate"])

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

func update_hunt_quota() -> void:
	if !GameManager.hunt_challenge_selected:
		return
	
	await get_tree().process_frame
	if map_type == MAP_TYPE.CHECKPOINT_FLOOR:
		if monster_spawn_node.get_children().is_empty():
			sfx_player.play_sfx(TIER_UP)
			MusicPlayer.play_song(hunt_victory_theme)
			GameManager.expedition_timer_started = false
			tower_entrance_data.hunt_challenge_completed = true
			SaveManager.save_floor_data(tower_entrance_data, map_name)
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


func play_sfx(audio_stream : AudioStream) -> void:
	if sfx_player:
		sfx_player.play_sfx(audio_stream)

func play_level_up_sfx() -> void:
	if sfx_player:
		sfx_player.play_sfx(TIER_UP)
