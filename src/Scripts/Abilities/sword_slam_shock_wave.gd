class_name SwordSlamShockWave extends Node2D


@export var move_speed : float
@export var flip_dir : bool = false
@export var move_dir : int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.flip_h = flip_dir
	animated_sprite_2d.play("default")
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(self, "global_position:x", global_position.x + (PlayerStats.equipped_abilities["Air Attack"].projectile_distance * move_dir), 0.3)
func _physics_process(delta: float) -> void:
	#position.x += move_speed * move_dir
	pass

func _on_timer_timeout() -> void:
	queue_free()



func flip_direction() -> void:
	flip_dir = true
	move_dir = -1


func _on_hit_box_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	
	if parent is Enemy:
		var damage = randf_range(PlayerStats.player_stats["Attack Damage"]*0.8, PlayerStats.player_stats["Attack Damage"]) * PlayerStats.equipped_abilities["Air Attack"].attack_damage_modifier
		parent.apply_slow_and_damage(damage, PlayerStats.equipped_abilities["Air Attack"].move_speed_modifier, PlayerStats.equipped_abilities["Air Attack"].slow_wait_time)
		#parent.apply_damage(damage,false)
