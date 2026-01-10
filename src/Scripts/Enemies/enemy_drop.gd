class_name EnemyDrop extends Resource

@export_group("Data")
@export var item_name : String
@export var drop_icon : Texture2D
@export var shop_icon : Texture2D
@export var base_sell_value : int

enum ITEM_TYPE {NOVELTY, COOKING, CRAFTING}
@export var item_type : ITEM_TYPE

 
