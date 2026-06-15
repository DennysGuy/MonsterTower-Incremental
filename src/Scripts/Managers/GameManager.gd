extends Node


var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_location : int = 0
var player_can_move : bool = true
var expedition_timer_started : bool = false
var previous_map_path : String
var resupply_character : bool = false
var previous_map_data : TowerEntranceData
var hunt_challenge_selected : bool = false
var can_pause_game : bool = true
var enemies_can_move : bool = true
var can_open_bag : bool = true
var can_open_tower_map : bool = true
var player_can_attack : bool = true
var auto_pick_up_enabled : bool = false
var can_issue_abilities : bool = true
var event_speed_mod : float = 1.0
var boss_door_challenge_active : bool = false
var on_boss_door_floor : bool = false
var room_speed_bonus : float = 1.0
var new_jobs_available : bool = false
var license_promotion_time : bool = false
var in_last_breadth_mode : bool = false
var remaining_bolt_chain_links : int = 0
var event_multiplier : float = 1.0

var first_class_just_unlocked : bool = false
var first_quest_just_unlocked : bool = false
var floor_2_just_reached : bool = false
var floor_4_just_reached : bool = false
var floor_6_just_reached : bool = false
var boss_room_just_reached : bool = false
var market_intro_cutscene_played : bool = false
var job_selection_notice_scene_played : bool = false
var monster_voices_toggled : bool = true
var current_player_health : int = 0
enum NOTIFICATION_TYPE {CRAFTING, COOKING, SMELTING, AP, QUEST}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_can_move = true
	spawn_location = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player_box_direction(flip_h : bool):
	if (flip_h):
		return -1
	else:
		return 1

func attack_enemies(enemies_in_hitbox : Array, enemies_hit : int = 1, number_of_hits : int = 1, player : Player = null, incoming_damage : int = 0, is_crit : bool = false, is_warrior : bool = false, rep_delay : float = 0.1, ability : Ability = null) -> void:
	var targets = calculate_targets(enemies_in_hitbox, player, enemies_hit)
	for enemy in targets:
		if is_instance_valid(enemy):
			# we may need to alter this line of code or the function.. I do not like how this function is dependent on the enemy.
			enemy.player = player
			#if it is a hitscan ability, we will determine the animation needed here.
			var attack_reps = number_of_hits + PlayerStats.get_total_gem_bonus("Hit Reps") + PlayerStats.get_current_sword().hit_bonus
			var i = 0
			var defense : float = clamp(
				enemy.enemy_stats.defense / 100.0,
				0.0,
				0.9
				)

			var damage = int(incoming_damage * (1.0 - defense))

			damage = max(damage, 1)
			var label_position : int = 60
			while i < attack_reps:
				#enemy.sfx_player.play()
				attack_enemy(player, enemy, damage, is_crit, 0, is_warrior, label_position, ability)

				i += 1
				label_position += 25
				await player.get_tree().create_timer(0.1).timeout
			
			if is_instance_valid(enemy) and enemy.health <= 0:
				enemies_in_hitbox.erase(enemy)

func attack_enemy(player : Player, enemy : Enemy, incoming_damage : int, is_crit : bool, hit_freeze : float = 0.02, is_warrior : bool = false, label_position : int = 40, ability : Ability = null) -> void:
	#SignalBus.shake_camera.emit(0.5)
	HitStopManager.freeze(hit_freeze, 0.1, 0.0, 0.03)
	if is_warrior:
		enemy.increment_break_count()
	
	if can_siphen():
		siphen_hp(incoming_damage)
	
	if ability:
		match ability.attack_type:
			ability.ATTACK_TYPE.NORMAL:
				enemy.apply_damage(incoming_damage, is_crit, label_position)
			ability.ATTACK_TYPE.SLOW:
				enemy.apply_slow_and_damage(incoming_damage, ability.move_speed_modifier, ability.slow_wait_time, is_crit)
			ability.ATTACK_TYPE.SILENCE:
				enemy.apply_silenced_and_damage(incoming_damage, ability.stun_wait_time, is_crit)
		return
	enemy.apply_damage(incoming_damage, is_crit, label_position)
	#might need to break here so we don't collide with the function below

func can_siphen() -> bool:
	var chance : int = int(PlayerStats.player_stats["HP Siphen Chance"]*100)
	var rand_num : int = randi_range(0,100)
	if chance <= rand_num:
		return true
	return false

func siphen_hp(amount : int) -> void:
	var siphened_amount : int = int(amount * PlayerStats.player_stats["HP Siphen Amount"])
	PlayerStats.player_stats["Current Health"] += siphened_amount
	if PlayerStats.player_stats["Current Health"] >= PlayerStats.player_stats["Max Health"]:
		PlayerStats.player_stats["Current Health"] = PlayerStats.player_stats["Max Health"]
	PlayerHudSignalBus.update_player_health.emit() 

func calculate_targets(enemies_in_hitbox : Array, player : Player, number_of_hits : int) -> Array[Entity]:
	var targets: Array[Entity] = []
	
	if enemies_in_hitbox.is_empty():
		return targets
	
	var sorted_enemies: Array = []
	
	for area in enemies_in_hitbox:
		var enemy = area.get_parent()
		
		if not enemy is Enemy:
			continue
		
		if not area is HurtBox:
			continue
		if enemy == null or enemy == player or not enemy.damageable:
			continue
		
		var distance = abs(enemy.global_position.x - player.global_position.x)
		sorted_enemies.append({"enemy": enemy, "distance": distance})
	
	sorted_enemies.sort_custom(func(a, b):
		return a["distance"] < b["distance"]
	)
	
	for i in range(min(number_of_hits, sorted_enemies.size())):
		targets.append(sorted_enemies[i]["enemy"])
	
	return targets

func set_direction(dir : float):
	if (dir < 0):
		return -1
	else:
		return 1

func enable_enemy_movement() -> void:
	enemies_can_move = true

func disable_enemy_movement() -> void:
	enemies_can_move = false

func can_unlock_class() -> bool:
	return PlayerStats.player_stats["Level"] >= 8 and PlayerStats.facilities_unlocked["Arial Slash"] and PlayerStats.facilities_unlocked["Dash"] and PlayerStats.facilities_unlocked["Double Jump"] and PlayerStats.player_stats["Class"] == "Junior Hunter"

func check_if_dodged() -> bool:
	var chance : int = int(PlayerStats.player_stats["Dodge Chance"] * 100)
	var rand_num : int = randi_range(0,100)
	if chance != 0 and rand_num <= chance:
		return true
	
	return false

func get_control_mapping(action : String,len : int = 1) -> String:
	var events = InputMap.action_get_events(action)
	var key = events[0]
	var mapping : String = key.as_text()
	mapping = mapping.substr(0,len)
	return mapping


func play_sfx(sound: AudioStream, volume: float = 0.0, pitch_scale : float = 1.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
