extends Node

var sword_textures : Dictionary = {
	"Wooden Sword": {
		"Idle": preload("uid://cqamv5bk70srn"),
		"Run": preload("uid://bav0xmrc5cgcy"),
		"Jump": preload("uid://dvjce5ajf3r0"),
		"Fall": preload("uid://dvjce5ajf3r0"),
		"SwordSwing1":preload("uid://bdefqkaq2k4dr"),
		"SwordSwing2":preload("uid://bdefqkaq2k4dr"),
		"SwordSwing3":preload("uid://bdefqkaq2k4dr")
	}
}

var pickaxe_textures : Dictionary = {
	"Stone Pickaxe": preload("uid://c1dxfmrpwv7a4")
}

func get_sword_graphic(texture_name : String) -> Texture2D:
	var sword_name : String = PlayerStats.get_sword().sword_name
	return sword_textures[sword_name][texture_name]

func get_pickaxe_graphic() -> Texture2D:
	var pickaxe_name : String = PlayerStats.get_pickaxe_name() #gonna rework into a resource later
	return pickaxe_textures[pickaxe_name]
