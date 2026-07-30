extends Node


var outfit_graphics : Dictionary = {
	"Junior Hunter": {
		"Idle": preload("uid://c7inonqhoemlt"),
		"Run": preload("uid://doypgng7koxsl"),
		"Jump": preload("uid://d2mhsxosuogyg"),
		"Fall": preload("uid://da01x6ypb46we"),
		"SwordSwing1": preload("uid://cshuuw4evmiqi"),
		"SwordSwing2":preload("uid://cshuuw4evmiqi"),
		"SwordSwing3":preload("uid://cshuuw4evmiqi"),
		"AirAttack":preload("uid://cshuuw4evmiqi"),
		"Climb": preload("uid://cqmq21ket8vvt"),
		"PickaxeSwing": preload("uid://cnf7idq4cexlj"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw"),
		"SwordSoar": preload("uid://byycfcy4i7vap"),
		"SwordSlam": preload("uid://c6outchyu637"),
		"BasicAttackEffect": preload("uid://bvj4nyj0lqt7s"),
		"CycloneSlash": preload("uid://cwehmdaknb5ko"),
		"IronBody": preload("uid://s3c87yot2mlq"),
		"CircleOfTruth": preload("uid://crb6j81csruty"),
		"BasicDash": preload("uid://dp8eilpd2k4li"),
		"Punch": preload("uid://0w3eyeg5v6bf")
	},
	"Tyro" : {
		"Idle": preload("uid://bsy5tgiwm7wxj"),
		"Run": preload("uid://d3k856go8d7y1"),
		"Jump": preload("uid://djvf2ohe2te8o"),
		"Fall": preload("uid://dax4hrmfncnu1"),
		"SwordSwing1": preload("uid://yr04pwemffgp"),
		"SwordSwing2":preload("uid://yr04pwemffgp"),
		"SwordSwing3":preload("uid://yr04pwemffgp"),
		"AirAttack":preload("uid://yr04pwemffgp"),
		"Climb": preload("uid://dk2em20jehn6b"),
		"PickaxeSwing": preload("uid://bik1x4xoyau24"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw"),
		"SwordSoar": preload("uid://byycfcy4i7vap"),
		"SwordSlam": preload("uid://c6outchyu637"),
		"BasicAttackEffect": preload("uid://cn3s2uyi5i0pn"),
		"CycloneSlash": preload("uid://cwehmdaknb5ko"),
		"IronBody": preload("uid://s3c87yot2mlq"),
		"CircleOfTruth": preload("uid://crb6j81csruty"),
		"BasicDash": preload("uid://qg85t3wo7ly")
	}
}

func get_outfit_graphic(animation_name : String) -> Texture2D:
	var player_class : String = PlayerStats.player_stats["Class"]
	return outfit_graphics[player_class][animation_name]
