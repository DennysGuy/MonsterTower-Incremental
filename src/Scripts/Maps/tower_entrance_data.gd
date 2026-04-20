class_name TowerEntranceData extends Resource

@export var floor_name : String
@export var floor_number : int
@export var hunt_challenge_time : int = 90
enum FLOOR_TYPE {EXPEDITION, CHALLENGE, BOSS_DOOR, BOSS_ROOM}
@export var unlock_recipe : CraftingRecipe
@export var floor_type : FLOOR_TYPE
@export var biome : String
@export var number_of_spawn_locations : int = 0 #this starts at index 0 and goes up. 
@export var camp_fires_reached : int  = 0
@export var total_camp_fires : int = 0

@export var hunt_challenge_unlocked : bool = false
@export var hunt_challenge_completed : bool = false
@export var scene_path : String
@export var preview_pictures : Array[Texture2D]

@export var kill_count_needed : int = 0
@export var current_count : int = 0
@export var activation_switch_unlocked : bool = false

@export var enemy_preview_graphics : Array[Texture2D]
@export var ore_rock_preview_graphics : Array[Texture2D]

func is_expedition_floor() -> bool:
	return floor_type == FLOOR_TYPE.EXPEDITION

func is_challenge_floor() -> bool:
	return floor_type == FLOOR_TYPE.CHALLENGE

func is_boss_door() -> bool:
	return floor_type == FLOOR_TYPE.BOSS_DOOR

func is_boss_floor() -> bool:
	return floor_type == FLOOR_TYPE.BOSS_ROOM 
