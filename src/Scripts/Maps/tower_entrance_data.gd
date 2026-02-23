class_name TowerEntranceData extends Resource

@export var floor_name : String
@export var biome : String
@export var number_of_spawn_locations : int = 0 #this starts at index 0 and goes up. 
@export var camp_fires_reached : int  = 0
@export var total_camp_fires : int = 0

@export var hunt_challenge_unlocked : bool = false
@export var hunt_challenge_completed : bool = false
@export var scene_path : String
@export var preview_pictures : Array[Texture2D]
