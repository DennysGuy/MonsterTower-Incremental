class_name Enemy extends Entity

@export var enemy_stats : EnemyStats
@export var name_tag : NameTag
@export var health_bar : EnemyHealthBar
@export var player : Player
@export var sprite : Sprite2D

@export_group("Detectors")
@export var wall_detector : RayCast2D
@export var ground_detector : RayCast2D

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


func start_fadeout() -> void:
	await get_tree().create_timer(1.0).timeout
	blink_effect()

func blink_effect() -> void:
	var invincibility_duration : float = 1.5
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration:
		set_textures_visibility(false)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
		set_textures_visibility(true)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
	
	queue_free()

func set_textures_visibility(value : bool) -> void:
	animation_player.visible = value


func player_is_dead():
	if player:
		player.is_dead = true
