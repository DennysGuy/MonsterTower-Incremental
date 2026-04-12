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
	if is_crit:
		damage_text = str(incoming_damage)+"!"
	else:
		damage_text = str(incoming_damage)
	
	if parent is Player:
		SignalBus.update_player_health.emit(parent.health)
		PlayerStats.player_stats["Current Health"] = parent.health
		print("THIS IS CURRENT PLAYER HEALTH IN STATS: %s" % PlayerStats.player_stats["Current Health"])
	if parent is Enemy and parent.health_bar:
		parent.health_bar.show()	
		update_health_bar.emit()	
		
	if parent.health <= 0:
		parent.health = 0
		
		if !parent.is_dead:
			parent.kill_me()
	else:
		parent.send_to_hit_state()

	return damage_text
