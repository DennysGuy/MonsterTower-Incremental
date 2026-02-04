extends Node

var sword_textures : Dictionary = {
	"Wooden Sword": {
		"Idle": preload("uid://cqamv5bk70srn"),
		"Run": preload("uid://bav0xmrc5cgcy"),
		"Jump": preload("uid://dvjce5ajf3r0"),
		"Fall": preload("uid://dvjce5ajf3r0"),
		"SwordSwing1":preload("uid://bdefqkaq2k4dr"),
		"SwordSwing2":preload("uid://bdefqkaq2k4dr"),
		"SwordSwing3":preload("uid://bdefqkaq2k4dr"),
		"AirAttack":preload("uid://bdefqkaq2k4dr")
	},
	"Shroom Fibre Blade" : {
		"Idle": preload("uid://cqrcj00btxto0"),
		"Run": preload("uid://dyoe7q5f07ia2"),
		"Jump": preload("uid://bhbydpkw1wwkn"),
		"Fall": preload("uid://bhbydpkw1wwkn"),
		"SwordSwing1": preload("uid://j7jrnmqku872"),
		"SwordSwing2": preload("uid://j7jrnmqku872"),
		"SwordSwing3": preload("uid://j7jrnmqku872"),
		"AirAttack": preload("uid://j7jrnmqku872")
	},
	"Bronze Fang Blade" : {
		"Idle": preload("uid://1gmop8x66tjk"),
		"Run": preload("uid://catadyl8hdysa"),
		"Jump": preload("uid://come635s2bqh"),
		"Fall": preload("uid://come635s2bqh"),
		"SwordSwing1": preload("uid://doai8hrrsivio"),
		"SwordSwing2": preload("uid://doai8hrrsivio"),
		"SwordSwing3": preload("uid://doai8hrrsivio"),
		"AirAttack": preload("uid://doai8hrrsivio")
	}
}

var pickaxe_textures : Dictionary = {
	"Stone Pickaxe": preload("uid://c1dxfmrpwv7a4")
}

func get_sword_graphic(texture_name : String) -> Texture2D:
	var sword_index : int = int(PlayerStats.player_stats["Equipped Sword"])
	var sword_name : String = PlayerStats.get_sword(sword_index).sword_name
	return sword_textures[sword_name][texture_name]

func get_pickaxe_graphic() -> Texture2D:
	var pickaxe_name : String = PlayerStats.get_pickaxe_name() #gonna rework into a resource later
	return pickaxe_textures[pickaxe_name]
