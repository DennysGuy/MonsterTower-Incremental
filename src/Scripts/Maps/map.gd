class_name Map extends Node2D

@export var map_name : String
@export var map_id : int
@export var tower_entrance_data : TowerEntranceData
@export var map_theme_song : AudioStream
@export var spawn_point : Marker2D
@export var player_spawn : bool = true
@export var camera : PlayerCamera
@export var hud : PlayerHUD
@export var ore_rock_spawn_rate : float
@export var ore_rock_markers : Node
@export var campfire_list : Node

@export var path : String
@export var next_room_path : String
@export var sfx_player : AudioStreamPlayer

enum MAP_TYPE {HUB, FLOOR, CHECKPOINT_FLOOR}

@export var map_type : MAP_TYPE = MAP_TYPE.HUB

var player : Player

@export var kill_quota : int = 0
@export var current_kill_count : int = 0

@export var ambience_player : AudioStreamPlayer
@export var ambience_sfx : AudioStream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_can_move = true
	GameManager.previous_map_path = path
	SignalBus.move_to_next_room.connect(move_to_next_room)
	SignalBus.return_to_starshire.connect(go_to_starshire)
	hud.map_name_label.text = map_name
	if player_spawn:
		if map_type == MAP_TYPE.CHECKPOINT_FLOOR and tower_entrance_data.number_of_spawn_locations <= 0:
			tower_entrance_data.number_of_spawn_locations += 1
		
		if campfire_list:
			for i in range(0,tower_entrance_data.camp_fires_reached):
				var checkpoint_campfire : CampFireCheckPoint = campfire_list.get_child(i)
				checkpoint_campfire.unlocked = true
				checkpoint_campfire.animation_player.play("On")
		
		spawn_player()
	
		if camera:
			camera.player = player
		
		if map_type == MAP_TYPE.CHECKPOINT_FLOOR:
			if tower_entrance_data.kill_quota_hit:
				SignalBus.unlock_next_room.emit()
				SignalBus.update_kill_quota_text.emit("Next Floor Unlocked!", tower_entrance_data.kill_quota_hit)
			else:
				SignalBus.update_kill_quota.connect(update_hunt_quota)
				SignalBus.update_kill_quota_text.emit("Floor Hunt Quota %s/%s" % [current_kill_count,kill_quota], false)

			PlayerStats.check_points_unlocked[map_name] = true
		
		if map_type ==	MAP_TYPE.FLOOR or map_type == MAP_TYPE.CHECKPOINT_FLOOR:
				hud.start_expedition_timer()
	
	if ambience_player and ambience_sfx:
		ambience_player.stream = ambience_sfx
		ambience_player.play()
	
	if MusicPlayer.audio_stream_player.is_playing:
		if map_theme_song:
			MusicPlayer.play_song(map_theme_song)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func spawn_player() -> void:
	var new_player : Player = preload("uid://wuy3aelq8aeg").instantiate()
	player = new_player
	var selected_spawn_point : PlayerSpawnPoint = choose_spawn_spoint()
	player.position = selected_spawn_point.position
	player.damageable = true
	add_child(player)
	
func go_to_starshire() -> void:
	MusicPlayer.stop_player(true)
	player.damageable = false
	GameManager.expedition_timer_started = false
	hud.animation_player.play("CloseOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/UI/ExpeditionResultsScreen.tscn")


func move_to_next_room() -> void:
	if next_room_path:
		hud.animation_player.play("CloseOut")
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(next_room_path)


func roll_ore_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * ore_rock_spawn_rate)

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

func update_hunt_quota() -> void:
	if map_type == MAP_TYPE.CHECKPOINT_FLOOR:
		current_kill_count += 1
		if current_kill_count >= kill_quota:
			tower_entrance_data.kill_quota_hit = true
			SignalBus.unlock_next_room.emit()
			SignalBus.update_kill_quota_text.emit("Next Floor Unlocked!", tower_entrance_data.kill_quota_hit)
		else:
			SignalBus.update_kill_quota_text.emit("Floor Hunt Quota %s/%s" %[current_kill_count,kill_quota], tower_entrance_data.kill_quota_hit)	
	
