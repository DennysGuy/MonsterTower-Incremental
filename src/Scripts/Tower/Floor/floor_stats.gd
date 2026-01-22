class_name FloorStats extends Resource

@export var floor_name : String
@export var biome : int
@export var floor_number : int
@export var enemy_cap : int
@export var ore_rock_cap : int
@export var enemy_list : Array

enum FLOOR_TYPE {STATIC, DYNAMIC}
@export var floor_type : FLOOR_TYPE
