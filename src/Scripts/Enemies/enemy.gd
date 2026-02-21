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

func _ready() -> void:
	super()
	health = enemy_stats.max_health
	
	if name_tag:
		name_tag.tag.text = "Lv.%s %s" % [enemy_stats.enemy_level, enemy_stats.enemy_name]
	
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health

func _exit_tree() -> void:
	if is_dead:
		if GameManager.hunt_challenge_selected:
			SignalBus.update_kill_quota.emit()

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

func apply_slow_and_damage(damage : int, issued_slow_factor : float, slow_wait_time : float) -> void:
	apply_damage(damage, false)
	animation_player.speed_scale = 0.6
	if status_effect_icon_bar:
		status_effect_icon_bar.add_slow_icon_to_bar()
		
	if slow_timer:
		slow_factor = issued_slow_factor
		slow_timer.wait_time = slow_wait_time
		slow_timer.start()
	# we'll need to check if we're already stunned so that the player can't stun enemies 
	# also is this too cheap? Maybe this can be balanced.
	increment_break_count()

func apply_silenced_and_damage(damage : int, silenced_wait_time : float) -> void:
	apply_damage(damage, false)
	if status_effect_icon_bar:
		status_effect_icon_bar.add_silenced_icon_to_bar()
	
	if silenced_timer:
		disable_hit_box()
		silenced_timer.wait_time = silenced_wait_time
		silenced_timer.start()

	increment_break_count()
		
func revert_slow_factor() -> void:
	if status_effect_icon_bar:
		status_effect_icon_bar.remove_slow_icon_from_bar()
	slow_factor = 1.0

func revert_silence() -> void:
	if status_effect_icon_bar:
		status_effect_icon_bar.remove_silenced_icon_from_bar()
	enable_hit_box()

func increment_break_count() -> void:
	if is_stunned:
		return
	
	if current_break_count < enemy_stats.break_threshold:
		current_break_count += 1
		vertical_status_icon_bar.add_break_status_icon(current_break_count,enemy_stats.break_threshold)
	else:
		vertical_status_icon_bar.remove_break_count_icon()
		current_break_count = 0
		is_stunned = true
		send_to_stun_state()
		#send to stun state?

func give_xp() -> void:
	PlayerStats.player_stats["Current XP"] += xp
	var xp_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	xp_label.set_crit_bg()
	xp_label.label.text = "%sXP" % xp
	xp_label.global_position.y = global_position.y-40
	xp_label.global_position.x = global_position.x+30
	drop_scene.add_child(xp_label)
		
	LevelingManager.check_for_level_up()
