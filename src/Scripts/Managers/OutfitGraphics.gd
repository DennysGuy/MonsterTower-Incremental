extends Node


var outfit_graphics : Dictionary = {
	"Junior Hunter": {
		"Idle": preload("uid://c7inonqhoemlt"),
		"Run": preload("uid://doypgng7koxsl"),
		"Jump": preload("uid://d2mhsxosuogyg"),
		"Fall": preload("uid://d2mhsxosuogyg"),
		"SwordSwing1": preload("uid://cshuuw4evmiqi"),
		"SwordSwing2":preload("uid://cshuuw4evmiqi"),
		"SwordSwing3":preload("uid://cshuuw4evmiqi"),
		"AirAttack":preload("uid://cshuuw4evmiqi"),
		"Climb": preload("uid://cqmq21ket8vvt"),
		"PickaxeSwing": preload("uid://cnf7idq4cexlj")
	}
}

func get_outfit_graphic(animation_name : String) -> Texture2D:
	var player_class : String = PlayerStats.player_stats["Class"]
	return outfit_graphics[player_class][animation_name]
