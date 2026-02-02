class_name EnemyDrop extends Item

@export_group("Data")
@export var drop_icon : Texture2D

enum ITEM_TYPE {NOVELTY, COOKING, CRAFTING, ORE}
@export var item_type : ITEM_TYPE
@export var drop_chance : float

 
