class_name EnemyStats extends Resource

@export_group("Meta Data")
@export var enemy_name : String
@export var enemy_level : int
@export var touch_damage : bool = false
@export var can_attack : bool = false
@export var can_move : bool = false

@export_group("Stats")
@export var max_health : int
@export var attack : int
@export var defense : float
@export var movement_speed : float
@export var chase_speed : float

@export_group("Audio Files")
@export var hit_sfx : AudioStream
@export var die_sfx : AudioStream
@export var movement_sfx : AudioStream
