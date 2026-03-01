class_name AbilityNodeStats extends Resource

@export var ability_name : String
@export var ability_description : String
@export var ap_cost : int
@export_multiline var description : String
@export var unlocked : bool = false
@export var max_level : int = 1
@export var current_level : int = 0
@export var materials_required : Array[Dictionary]

@export_group("Player Stat Data")
@export var stat_name : String
@export var upgrade_interval : float = 0
@export var level_prereq : int = 1
