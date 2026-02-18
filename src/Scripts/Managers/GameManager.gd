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

func attack_enemies(enemies_in_hitbox : Array, number_of_hits : int, player : Player, incoming_damage : int, is_crit : bool = false) -> void:
	var targets = calculate_targets(enemies_in_hitbox, player, number_of_hits)
	for enemy in targets:
		if is_instance_valid(enemy):
			# we may need to alter this line of code or the function.. I do not like how this function is dependent on the enemy.
			enemy.player = player
			#if it is a hitscan ability, we will determine the animation needed here.
			var attack_reps = number_of_hits
			var i = 0
			
			while i < attack_reps:
				#enemy.sfx_player.play()
				attack_enemy(player, enemy, incoming_damage, is_crit)
				i += 1
				await player.get_tree().create_timer(0.1).timeout
			
			if is_instance_valid(enemy) and enemy.health <= 0:
				enemies_in_hitbox.erase(enemy)
				#enemy.dead = true
			#await player.get_tree().create_timer(0.1).timeout

func attack_enemy(player : Player, enemy : Enemy, incoming_damage : int, is_crit : bool, hit_freeze : float = 0.02) -> void:
	SignalBus.shake_camera.emit(0.5)
	HitStopManager.freeze(hit_freeze, 0.1, 0.0, 0.03)
	enemy.apply_damage(incoming_damage, is_crit)

func calculate_targets(enemies_in_hitbox : Array, player : Player, number_of_hits : int) -> Array[Entity]:
	var targets: Array[Entity] = []
	
	if enemies_in_hitbox.is_empty():
		return targets
	
	var sorted_enemies: Array = []
	
	for area in enemies_in_hitbox:
		var enemy = area.get_parent()
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
