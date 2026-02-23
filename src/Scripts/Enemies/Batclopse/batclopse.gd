class_name Batclopse extends Enemy

@onready var timer: Timer = $Timer

var can_chase : bool = false

func _ready() -> void:
	super()
	
func _on_health_component_update_health_bar() -> void:
	update_health_bar()

func _on_hit_box_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	
	if not area_parent is Player:
		return
	
	if not area is HurtBox:
		return
	
	if !area_parent.damageable or area_parent.is_dead:
		return
			
	area_parent.stored_enemy = self
	var damage : int = randi_range(int(enemy_stats.attack * 0.8), enemy_stats.attack)
	damage -= int(damage * PlayerStats.player_stats["Defense"] * PlayerStats.get_sword(PlayerStats.player_stats["Equipped Sword"]).defense_bonus)
	area_parent.apply_damage(damage,false)
	
func _on_slow_timer_timeout() -> void:
	animation_player.speed_scale = 1.0
	revert_slow_factor()


func _on_silenced_timer_timeout() -> void:
	
	revert_silence()
