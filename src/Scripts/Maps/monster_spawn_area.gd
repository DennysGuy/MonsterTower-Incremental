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

var player_in_range : bool = false

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
	var cur_monsters: int = monster_spawn_list.get_children().size()
	var missing_monsters := max_monsters - cur_monsters

	if missing_monsters <= 0:
		return

	var monster_diff := randi_range(1, missing_monsters)

	var player: Player = get_tree().get_first_node_in_group("Player")

	var shape := area_collision_shape.shape as RectangleShape2D
	var extents = shape.extents

	for i in range(monster_diff):
		var scene := choose_enemy()
		if scene == null:
			continue

		var monster: Enemy = scene.instantiate()

		var spawn_x: float

		if player:
			spawn_x = get_spawn_x(player, extents)

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

func get_spawn_x(player: Player, extents: Vector2) -> float:
	if player:
		var player_offset := player.global_position.x - global_position.x

		if player_offset > 0:
			# Player is right side, spawn left
			return randf_range(-extents.x, 0)
		else:
			# Player is left side, spawn right
			return randf_range(0, extents.x)
	
	return 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false


func get_player() -> Player:
	for child in get_children():
		if child is Player:
			return child
	
	return null
