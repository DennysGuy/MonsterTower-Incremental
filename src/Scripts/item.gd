class_name Item extends Resource

enum ITEM_TYPE {NOVELTY, COOKING, CRAFTING, ORE, GEMSTONE, USE}

@export_group("Data")
@export var item_name : String
@export var item_type : ITEM_TYPE
@export var sell_value : int
@export var shop_icon : Texture2D
@export_multiline var description : String

func is_novelty() -> bool:
	return item_type == ITEM_TYPE.NOVELTY

func is_cooking() -> bool:
	return item_type == ITEM_TYPE.COOKING

func is_crafting() -> bool:
	return item_type == ITEM_TYPE.CRAFTING

func is_ore() -> bool:
	return item_type == ITEM_TYPE.ORE

func is_gemstone() -> bool:
	return item_type == ITEM_TYPE.GEMSTONE

func is_use() -> bool:
	return item_type == ITEM_TYPE.USE

func get_inventory_name() -> String:
	match item_type:
		ITEM_TYPE.NOVELTY:
			return "Inventory"
		ITEM_TYPE.COOKING:
			return "Inventory"
		ITEM_TYPE.CRAFTING:
			return "Inventory"
		ITEM_TYPE.ORE:
			return "Ore"
		ITEM_TYPE.GEMSTONE:
			return "Gem Stones"
		ITEM_TYPE.USE:
			return "Use"
		_:
			return "Inventory"
