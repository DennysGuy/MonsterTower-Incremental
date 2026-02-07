class_name MonsterSpawnArea extends Area2D


@export var min_spawn : int
@export var min_hunt_challenge_spawn : int
@export var max_spawn : int
@export var max_hunt_challenge_spawn : int
@export var drop_scene : Map
@export var spawn_root : Node

@export var monster_list : Dictionary[PackedScene, int]
@export var area_collision_shape : CollisionShape2D

var spawn_count : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.spawn_enemies.connect(_spawn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_enemy() -> PackedScene:
	var total_weight : int = 0
	
	for enemy in monster_list.keys():
		total_weight += monster_list[enemy]
	
	if total_weight <= 0:
		return
	
	var roll : float = randf() * total_weight
	
	for enemy in monster_list.keys():
		roll -= monster_list[enemy]
		if roll <= 0:
			return enemy

	return null

func _spawn():
	if !GameManager.hunt_challenge_selected:
		var capacity_bonus : int = int(PlayerStats.player_stats["Monster Cap Bonus"])
		spawn_count = randi_range(min_spawn + capacity_bonus, max_spawn + capacity_bonus)
	else:
		spawn_count = randi_range(min_hunt_challenge_spawn, max_hunt_challenge_spawn)
	
	for i in range(spawn_count):
		var scene := choose_enemy()
		if scene == null:
			continue

		var monster : Enemy = scene.instantiate()

		var shape := area_collision_shape.shape as RectangleShape2D
		var extents = shape.extents

		var spawn_x := randf_range(-extents.x, extents.x)
		var world_pos := global_position + Vector2(spawn_x, 0)
		
		monster.drop_scene = drop_scene
		monster.global_position = world_pos
		spawn_root.add_child(monster)
