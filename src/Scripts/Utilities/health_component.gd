class_name HealthComponent extends Node

@onready var damage_taken_label : Label = $"../DamageTaken"
@export var parent : Entity
@export var health_bar : TextureProgressBar

signal update_health_bar
func apply_healing(health: float):
	parent.stats_resource.current_health = min(parent.stats_resource.max_health, parent.stats_resource.current_health + health)

func apply_mp_replenish(magic_points : float):
	parent.stats_resource.current_magic_points = min(parent.stats_resource.magic_points, parent.stats_resource.current_magic_points + magic_points)

func apply_damage(incoming_damage : int, is_crit : bool) -> String:
	var damage_text : String
	parent.health -= incoming_damage
	if is_crit and incoming_damage != 0:
		damage_text = str(incoming_damage)+"!!"
	else:
		if incoming_damage <= 0:
			damage_text = "Miss"
		else:
			damage_text = str(incoming_damage)
	
	if parent is Player:
		PlayerStats.player_stats["Current Health"] = parent.health
		PlayerHudSignalBus.update_player_health.emit()
		if parent.health <= PlayerStats.player_stats["Last Breadth Threshold"]:
			GameManager.in_last_breadth_mode = true
		else:
			GameManager.in_last_breadth_mode = false
		
	if parent is Enemy:
		
		if parent.health_bar:	
			parent.health_bar.show()	
			update_health_bar.emit()
				
		if !(parent is Boss) and can_insta_kill(int(parent.health)):
			#probably play a special sfx for when it lands here
			#also will play some sort of visual
			parent.health = 0
	
	if parent.health <= 0:
		parent.health = 0
		
		if parent is Boss:
			PlayerHudSignalBus.update_boss_hp_bar.emit(parent.enemy_stats.max_health, parent.health)
		
		if !parent.is_dead:
			parent.kill_me()
	else:
		if parent is Boss:
			PlayerHudSignalBus.update_boss_hp_bar.emit(parent.enemy_stats.max_health, parent.health)
		parent.send_to_hit_state()

	return damage_text

func can_insta_kill(health_amount : int) -> bool:
	var chance : float = int(PlayerStats.player_stats["Insta Kill Chance"] * 100)
	var rand_num : int = randi_range(0, 100)
	var threshold_met : bool = health_amount <= PlayerStats.player_stats["Insta Kill Threshold"]
	if rand_num <= chance and threshold_met:
		return true
	
	return false
