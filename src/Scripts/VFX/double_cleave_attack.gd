class_name DoubleCleaveAttack extends EnemyProjectile


@onready var double_cleave_sword: Sprite2D = $DoubleCleaveSword


@onready var timer: Timer = $Timer
@onready var hit_box: HitBox = $HitBox
@onready var ability : Ability = PlayerStats.equipped_abilities["Combat Ability 4"]
var can_attack : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flip_dir:
		double_cleave_sword.flip_h = true
	attack_damage = int(ability.attack_damage_modifier * PlayerStats.player_stats["Attack Damage"])
	var tween : Tween = create_tween()
	tween.tween_property(double_cleave_sword, "modulate:a", 0.95, 0.1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.x += move_speed * move_dir


func _on_timer_timeout() -> void:
	issue_attack(hit_box, ability.attack_damage_modifier, ability, 0.2)
	var tween : Tween = create_tween()
	tween.tween_property(double_cleave_sword, "modulate:a", 0.85, 0.1)
	await tween.finished
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy and can_attack:
		issue_attack(hit_box, ability.attack_damage_modifier, null, 0.2)
		times_hit += 1
		if times_hit == max_times_hit:
			queue_free()	
	
