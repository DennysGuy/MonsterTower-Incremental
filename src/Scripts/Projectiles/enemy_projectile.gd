class_name EnemyProjectile extends Node2D

@export var attack_damage : int
@export var enemy : Enemy

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
	var defense : float = clamp(
	((PlayerStats.player_stats["Defense"] + PlayerStats.get_current_sword().get_total_defense_bonus()) / 100.0) * PlayerStats.defense_buff_mod,
	0.0,
	0.9
	)
	
	damage = int(damage * (1.0 - defense))

	damage = max(damage, 1)
	area_parent.apply_damage(damage,false)
