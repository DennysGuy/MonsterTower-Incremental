class_name Enemy extends Entity

@export var enemy_name : String
@export var enemy_stats : EnemyStats
@export var name_tag : NameTag
@export var health_bar : EnemyHealthBar
@export var player : Player

var health : float

func _ready() -> void:
	super()
	health = enemy_stats.max_health
	
	if name_tag:
		name_tag.tag.text = "Lv.%s %s" % [enemy_stats.enemy_level, enemy_stats.enemy_name]
	
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health
		

func apply_damage(incoming_damage : int, is_crit : bool) -> void:
	var true_damage = incoming_damage * (incoming_damage/(incoming_damage+enemy_stats.defense))
	var damage = health_component.apply_damage(true_damage, is_crit)
	
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	if is_crit:
		damage_label.set_crit_bg()
	damage_label.global_position.y = global_position.y-40
	damage_label.global_position.x = global_position.x
	damage_label.label.text = damage
	
	get_parent().add_child(damage_label)


func _process(delta: float) -> void:
	super(delta)
	if player == null:
		var spawned_player : Player = get_tree().get_first_node_in_group("Player")
		player = spawned_player
		print(player)

func update_health_bar() -> void:
	health_bar.value = health
