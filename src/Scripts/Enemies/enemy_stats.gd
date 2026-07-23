class_name EnemyStats extends Resource

@export_group("Meta Data")
@export var enemy_name : String
@export var enemy_level : int
@export var index : int
@export var preview_icon : Texture2D
@export var touch_damage : bool = false
@export var can_attack : bool = false
@export var can_move : bool = false
@export var idle_animation : Texture2D
@export var floor_locations : Array[String]
@export_enum("Aggro", "PassiveAggro", "Passive") var enemy_type : int
enum ENEMY_TYPE {AGGRO, PASSIVEAGGRO, PASSIVE}
enum BIOME {MOSSY_DUNGEON}
@export var biome : BIOME = BIOME.MOSSY_DUNGEON

@export_group("Stats")
@export var max_health : int
@export var attack : int
@export var defense : float
@export var movement_speed : float
@export var chase_speed : float
@export var break_threshold : int

@export_group("Audio Files")
@export var hit_sfx : AudioStream
@export var die_sfx : AudioStream
@export var hit_vox_1 : AudioStream
@export var hit_vox_2 : AudioStream
@export var hit_vox_3 : AudioStream
@export var die_vox : AudioStream
@export var movement_sfx : AudioStream

@export_group("Item Drops")
@export var novelty_item_drop : Item
@export var cooking_item_drop : Item
@export var crafting_item_drop : Item

func is_passive() -> bool:
	return enemy_type == ENEMY_TYPE.PASSIVE

func is_passive_aggro() -> bool:
	return enemy_type == ENEMY_TYPE.PASSIVEAGGRO

func is_aggro() -> bool:
	return enemy_type == ENEMY_TYPE.AGGRO 

func get_biome_name() -> String:
	match biome:
		BIOME.MOSSY_DUNGEON:
			return "Mossy Dungeon"
	
	return ""

func get_random_hit_vox() -> AudioStream:
	var vox_range : Array[AudioStream] = [hit_vox_1,hit_vox_2,hit_vox_3]
	return vox_range.pick_random()
