class_name Enemy extends Entity

@export var enemy_stats : EnemyStats
@export var can_knock_back : bool = true
@export var name_tag : NameTag
@export var health_bar : EnemyHealthBar
@export var player : Player

@export_group("Detectors")
@export var wall_detector : RayCast2D
@export var ground_detector : RayCast2D

func _ready() -> void:
	super()
	health = enemy_stats.max_health
	
	if name_tag:
		name_tag.tag.text = "Lv.%s %s" % [enemy_stats.enemy_level, enemy_stats.enemy_name]
	
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health
		

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


func player_is_dead():
	if player:
		player.is_dead = true


func apply_direction(new_dir: int) -> void:
	ground_detector.position.x = abs(ground_detector.position.x) * new_dir
	wall_detector.position.x = abs(wall_detector.position.x) * new_dir
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * new_dir
	wall_detector.rotation *= new_dir
	wall_detector.force_raycast_update()
	
	prev_dir = new_dir
	sprite.flip_h = new_dir < 0
