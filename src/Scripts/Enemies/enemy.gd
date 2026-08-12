class_name Enemy extends Entity

@export var enemy_stats : EnemyStats
@export var can_knock_back : bool = true
@export var xp : int
@export var name_tag : NameTag
@export var health_bar : EnemyHealthBar
@export var player : Player
@export var drop_scene : Map


@export var status_effect_icon_bar : StatusEffectIconBar
@export var vertical_status_icon_bar : StatusEffectVBox

@export_group("Timers")
@export var slow_timer : Timer
@export var silenced_timer : Timer

@export_group("Detectors")
@export var wall_detector : RayCast2D
@export var ground_detector : RayCast2D

var slow_factor : float = 1.0
var current_break_count : int = 0

const HIT_FLASH_MATERIAL = preload("uid://b754xqklvswat")


func _ready() -> void:
	super()
	SignalBus.disable_enemy_hit_box.connect(disable_hit_box)
	SignalBus.enable_enemy_hit_box.connect(enable_hit_box)
	health = enemy_stats.max_health
	
	if name_tag:
		name_tag.hide()
		name_tag.tag.text = "Lv.%s %s" % [enemy_stats.enemy_level, enemy_stats.enemy_name]
	
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health

func _exit_tree() -> void:
	pass
		

func _process(delta: float) -> void:
	super(delta)
	if player == null:
		var spawned_player : Player = get_tree().get_first_node_in_group("Player")
		player = spawned_player

func update_health_bar() -> void:
	health_bar.value = health

func start_fadeout() -> void:
	await get_tree().create_timer(0.5).timeout
	blink_effect()

func player_is_dead():
	if player:
		player.is_dead = true

func apply_direction(new_dir: int) -> void:
	ground_detector.position.x = abs(ground_detector.position.x) * new_dir
	wall_detector.position.x = abs(wall_detector.position.x) * new_dir
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * new_dir
	wall_detector.rotation *= new_dir
	wall_detector.force_raycast_update()
	
	prev_dir = new_dir
	sprite.flip_h = new_dir < 0

func apply_slow_and_damage(damage : int, issued_slow_factor : float, slow_wait_time : float, is_crit : bool = false) -> void:
	if PlayerStats.player_stats["Class"] == "Tyro":
		event_multiplier = 0.1
		increment_break_count()

	apply_damage(damage, is_crit)
	
	if status_effect_icon_bar:
		status_effect_icon_bar.add_slow_icon_to_bar()
		
	if slow_timer:
		animation_player.speed_scale = 0.6
		slow_factor = issued_slow_factor
		slow_timer.wait_time = slow_wait_time
		slow_timer.start()
	# we'll need to check if we're already stunned so that the player can't stun enemies 
	# also is this too cheap? Maybe this can be balanced.

func apply_silenced_and_damage(damage : int, silenced_wait_time : float, is_crit : bool = false) -> void:
	if PlayerStats.player_stats["Class"] == "Tyro":
		increment_break_count()
		event_multiplier = 4.0
	
	knock_back_direction = -1
	
	apply_damage(damage, is_crit)
	if status_effect_icon_bar:
		status_effect_icon_bar.add_silenced_icon_to_bar()
	
	if silenced_timer:
		is_silenced = true
		disable_hit_box()

		silenced_timer.wait_time = silenced_wait_time
		silenced_timer.start()
	
	
func revert_slow_factor() -> void:
	if status_effect_icon_bar:
		status_effect_icon_bar.remove_slow_icon_from_bar()
	slow_factor = 1.0

func revert_silence() -> void:
	if status_effect_icon_bar:
		status_effect_icon_bar.remove_silenced_icon_from_bar()
	if !is_dead:
		is_silenced = false
		enable_hit_box()

func increment_break_count() -> void:
	if is_stunned:
		return
	
	if current_break_count >= enemy_stats.break_threshold and !is_stunned:
		if vertical_status_icon_bar:
			vertical_status_icon_bar.remove_break_count_icon()
			current_break_count = 0
			is_stunned = true
	else:
		current_break_count += PlayerStats.player_stats["Stun Stacks"]
		if vertical_status_icon_bar:
			vertical_status_icon_bar.add_break_status_icon(current_break_count,enemy_stats.break_threshold)
		#send to stun state?

func give_xp() -> void:
	var stat_xp : int = PlayerStats.player_stats["Bonus XP"]
	var total_xp : int = int(xp+stat_xp)
	
	PlayerStats.player_stats["Current XP"] += total_xp
	var xp_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	xp_label.set_crit_bg()
	xp_label.label.text = "%sXP" % total_xp
	xp_label.global_position.y = global_position.y-50
	xp_label.global_position.x = global_position.x-56
	drop_scene.add_child(xp_label)
	SaveManager.save_player_stats()
	LevelingManager.check_for_level_up()

func set_enemy_hit_flash_material() -> void:
	sprite.material = HIT_FLASH_MATERIAL.duplicate()

func hit_surrounding_enemies(combat_ability: Ability) -> void:
	var enemies_in_tree: Array[Node] = get_tree().get_nodes_in_group("Enemy")
	var enemies_to_hit: Array[Enemy] = [self]
	var max_enemies_to_hit: int = int(combat_ability.number_of_enemies_hit)

	var dir: int = sign(player.global_position.x - global_position.x)

	for enemy in enemies_in_tree:
		var selected_enemy: Enemy = enemy
		
		if selected_enemy == self:
			continue
		
		if abs(global_position.y - selected_enemy.global_position.y) > 5.0:
			continue
		
		var x_distance: float = selected_enemy.global_position.x - global_position.x
		
		if dir < 0:
			if x_distance > 0 and x_distance <= 400:
				enemies_to_hit.append(selected_enemy)
		
		elif dir > 0:
			if x_distance < 0 and x_distance >= -400:
				enemies_to_hit.append(selected_enemy)

	var updated_enemy_hit_list: Array = enemies_to_hit.slice(0, max_enemies_to_hit)

	if not updated_enemy_hit_list.is_empty():
		var multiplier: float = combat_ability.attack_damage_modifier
		
		for enemy in updated_enemy_hit_list:
			var selected_enemy: Enemy = enemy
			selected_enemy.apply_damage(50 * multiplier, false)
			
			multiplier = max(1.0, multiplier - 0.2)
			
			if is_inside_tree() and selected_enemy.is_inside_tree():
				await get_tree().create_timer(0.1).timeout
