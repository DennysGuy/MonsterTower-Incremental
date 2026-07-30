class_name EnemyProjectile extends Node2D

@export var attack_damage : int
@export var enemy : Enemy
@export var move_speed : float
@export var flip_dir : bool = false
@export var move_dir : int = 1
@export var player : Player
var times_hit : int = 0
@export var max_times_hit : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func damage_player(area : Area2D) -> void:
	var area_parent = area.get_parent()
	
	if not area_parent is Player:
		return
	
	if !area_parent.damageable or area_parent.is_dead:
		return
	
	if not area is HurtBox:
		return
	
	area_parent.stored_enemy = enemy

	var damage : int = randi_range(int(attack_damage * 0.8), attack_damage)
	var defense = PlayerStats.player_stats["Defense"] + PlayerStats.get_current_sword().get_total_defense_bonus()
	var reduction = defense / (defense + GameManager.DEFENSE_SCALE)

	damage = int(damage * (1.0 - reduction))
	damage = max(damage, 1)
	area_parent.apply_damage(damage,false)


func issue_attack(selected_hit_box : Area2D, multiplier : float = 1.0, ability : Ability = null, hit_freeze : float = 0.0) -> void:
	var enemies_in_range = selected_hit_box.get_overlapping_areas()
	#var overlapping_hits : int = int(PlayerStats.player_stats["Overlapping Hits"] + PlayerStats.get_current_sword().get_total_multi_enemies_bonus())
	var overlapping_hits : int = int(PlayerStats.player_stats["Overlapping Hits"] + PlayerStats.get_current_sword().get_total_multi_enemies_bonus())
	var number_of_hits : int = 1
	var rep_delay : float = 0.1
	var incoming_damage : int = 0
	var total_base_attack_damage = int(PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().attack_bonus + PlayerStats.get_total_gem_attack_bonus())
	
	var min_damage : int = int(total_base_attack_damage * PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
	var max_damage : int = int(total_base_attack_damage)
	var is_crit = check_for_crit()
	
	if ability:
		overlapping_hits = int(ability.number_of_enemies_hit + PlayerStats.get_current_sword().get_total_multi_enemies_bonus())
		number_of_hits = int(ability.max_hit_count)
		rep_delay = ability.attack_rep_delay
		min_damage = total_base_attack_damage * (PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
		max_damage = int(total_base_attack_damage  + ability.base_attack)
		
	incoming_damage  = int(randi_range(min_damage,max_damage) * multiplier)
	
	if is_crit:
		incoming_damage = int((PlayerStats.player_stats["Crit Damage"] + PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Damage Bonus")) * incoming_damage)
	
	print("GAGA %s" % PlayerStats.get_current_sword().knock_back_bonus)
	if PlayerStats.player_stats["Class"] == "Tyro":
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, player, incoming_damage, is_crit, true, rep_delay,ability, hit_freeze)
	else:
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, player, incoming_damage, is_crit, false, rep_delay,ability, hit_freeze)

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func flip_direction() -> void:
	flip_dir = true
	move_dir = -1

func check_for_crit() -> bool:
	var crit_roll : int = randi_range(0,100)
	if crit_roll < int(100 * (PlayerStats.player_stats["Crit Chance"] + PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Chance Bonus"))):
		return true
	return false
