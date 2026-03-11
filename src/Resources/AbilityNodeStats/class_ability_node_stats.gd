class_name ClassAbilityNodeStats extends Resource

@export_group("Data")

@export var icon : Texture2D
@export var node_name : String
@export var class_relation : String #name of the class
@export_multiline var description : String
@export var unlocked : bool = false
@export var ap_cost : int = 0
enum NODE_TYPE {ABILITY_UNLOCK, ABILITY_STAT_BOOST, CHARACTER_STAT_BOOST, CLASS_ADVANCE}
@export var node_type : NODE_TYPE
@export var materials_required : Array[Dictionary]

@export_group("Upgrades")

@export var ability_category : String
@export var ability_resource : Ability
