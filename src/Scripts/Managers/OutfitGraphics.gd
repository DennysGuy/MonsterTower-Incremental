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
		"PickaxeSwing": preload("uid://cnf7idq4cexlj"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw")
	},
	"Tyro" : {
		"Idle": preload("uid://bsy5tgiwm7wxj"),
		"Run": preload("uid://d3k856go8d7y1"),
		"Jump": preload("uid://djvf2ohe2te8o"),
		"Fall": preload("uid://djvf2ohe2te8o"),
		"SwordSwing1": preload("uid://yr04pwemffgp"),
		"SwordSwing2":preload("uid://yr04pwemffgp"),
		"SwordSwing3":preload("uid://yr04pwemffgp"),
		"AirAttack":preload("uid://yr04pwemffgp"),
		"Climb": preload("uid://dk2em20jehn6b"),
		"PickaxeSwing": preload("uid://bik1x4xoyau24"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw")
	}
}

func get_outfit_graphic(animation_name : String) -> Texture2D:
	var player_class : String = PlayerStats.player_stats["Class"]
	return outfit_graphics[player_class][animation_name]
