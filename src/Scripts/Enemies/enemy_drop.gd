class_name EnemyDrop extends Item

@export_group("Data")
@export var drop_icon : Texture2D

enum ITEM_TYPE {NOVELTY, COOKING, CRAFTING, ORE}
@export var item_type : ITEM_TYPE
@export var drop_chance : float

func is_novelty() -> bool:
	return item_type == ITEM_TYPE.NOVELTY

func is_cooking() -> bool:
	return item_type == ITEM_TYPE.COOKING 

func is_crafting() -> bool:
	return item_type == ITEM_TYPE.CRAFTING

func is_ore() -> bool:
	return item_type == ITEM_TYPE.ORE 
