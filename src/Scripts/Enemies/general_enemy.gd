class_name GenericEnemy extends Enemy

@warning_ignore("unused_signal")
signal on_death
@onready var timer: Timer = $Timer

var can_chase : bool = false

func _ready() -> void:
	super()
	print(global_position)

func _on_health_component_update_health_bar() -> void:
	update_health_bar()

func _on_hit_box_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	
	if not area_parent is Player:
		return
	
	if !area_parent.damageable or area_parent.is_dead:
		return
	
	if not area is HurtBox:
		return
	
	area_parent.stored_enemy = self

	var damage : int = randi_range(int(enemy_stats.attack * 0.8), enemy_stats.attack)
	var defense : float = clamp(
	((PlayerStats.player_stats["Defense"] + PlayerStats.get_current_sword().get_total_defense_bonus()) / 100.0) * PlayerStats.defense_buff_mod,
	0.0,
	0.9
	)
	
	damage = int(damage * (1.0 - defense))
	damage = max(damage, 1)
	area_parent.apply_damage(damage,false)
	
func _on_slow_timer_timeout() -> void:
	animation_player.speed_scale = 1.0
	revert_slow_factor()

func _on_silenced_timer_timeout() -> void:
	revert_silence()
