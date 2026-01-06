class_name Enemy extends Entity

@export var enemy_name : String
@export var enemy_stats : EnemyStats
@export var name_tag : NameTag
@export var health_bar : EnemyHealthBar

var health : float

func _ready() -> void:
	super()
	health = enemy_stats.max_health
	
	if name_tag:
		name_tag.tag.text = "Lv.%s %s" % [enemy_stats.enemy_level, enemy_stats.enemy_name]
	
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health
		
