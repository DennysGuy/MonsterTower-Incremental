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

func get_sword_graphic(texture_name : String) -> Texture2D:
	var sword_name : String = PlayerStats.get_sword_name()
	print(sword_name)
	print(texture_name)
	return sword_textures[sword_name][texture_name]
