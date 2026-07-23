class_name MonsterSpawnArea extends Area2D

@export var max_monsters : int = 3
@export var respawn_wait_time : float = 1.0
@export var can_respawn : bool = true

@export var min_spawn : int
@export var min_hunt_challenge_spawn : int
@export var max_spawn : int
@export var max_hunt_challenge_spawn : int
@export var drop_scene : Map
@export var spawn_root : Node

@export var monster_list : Dictionary[PackedScene, int]

@export var challenge_monster_list : Dictionary[PackedScene, int]

@export var area_collision_shape : CollisionShape2D

@onready var respawn_timer: Timer = $RespawnTimer
@onready var monster_spawn_list: Node = $MonsterSpawnList

var can_spawn : bool = true

var spawn_count : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.spawn_enemies.connect(_spawn)
	SignalBus.start_enemy_spawn.connect(start_enemy_spawn)
	CutsceneManager.stop_enemy_spawn.connect(disable_spawn)
	CutsceneManager.start_enemy_spawn.connect(start_enemy_spawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_enemy() -> PackedScene:
	var selected_monster_list = monster_list
	
	if GameManager.hunt_challenge_selected:
		selected_monster_list = challenge_monster_list
	
	var total_weight : int = 0
	
	for enemy in selected_monster_list.keys():
		total_weight += selected_monster_list[enemy]
	
	if total_weight <= 0:
		return
	
	var roll : float = randf() * total_weight
	
	for enemy in selected_monster_list.keys():
		roll -= selected_monster_list[enemy]
		if roll <= 0:
			return enemy

	return null

func _spawn():
	if !GameManager.hunt_challenge_selected:
		var capacity_bonus : int = int(PlayerStats.player_stats["Monster Cap Bonus"])
		spawn_count = randi_range(min_spawn + capacity_bonus, max_monsters + capacity_bonus)
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
		if GameManager.hunt_challenge_selected:
			spawn_root.add_child(monster)
		else:
			monster_spawn_list.add_child(monster)

func respawn_monsters() -> void:
	var cur_monsters : int = monster_spawn_list.get_children().size()
	var monster_diff : int = randi_range(1, max_monsters-cur_monsters)
	for i in range(monster_diff):
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
		monster_spawn_list.add_child(monster)

func start_enemy_spawn() -> void:
	enable_spawn()
	respawn_timer.wait_time = respawn_wait_time
	respawn_timer.start()

func _on_respawn_timer_timeout() -> void:
	if monster_spawn_list.get_children().size() < max_monsters and can_spawn:
		respawn_monsters()

func enable_spawn() -> void:
	can_spawn = true
	

func disable_spawn() -> void:
	can_spawn = false
