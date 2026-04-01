extends Node

var sword_textures : Dictionary = {
	"Wooden Sword": {
		"Idle": preload("uid://n5geiar8phy6"),
		"Run": preload("uid://dwvt17upbk5hi"),
		"Jump":preload("uid://bqdfkvfxebubj"),
		"Fall": preload("uid://c5bjas3biimxg"),
		"SwordSwing1":preload("uid://bbhb6o4x6k1t8"),
		"SwordSwing2":preload("uid://bbhb6o4x6k1t8"),
		"SwordSwing3":preload("uid://bbhb6o4x6k1t8"),
		"AirAttack":preload("uid://bbhb6o4x6k1t8"),
		"Climb":preload("uid://bxp4omipurasx"),
		"SwordSoar": preload("uid://bju208fm34q1i"),
		"SwordSlam": preload("uid://b7dgsrumi85gy"),
		"DoubleCleave": preload("uid://ubudq3lg48pa")
	},
	"Shroom Fibre Blade" : {
		"Idle": preload("uid://decldm83dahcq"),
		"Run": preload("uid://cfclykhkthvqp"),
		"Jump": preload("uid://bff30bwg0yuos"),
		"Fall": preload("uid://c23i8xo64kl1i"),
		"SwordSwing1": preload("uid://c3eh7fshh2m0t"),
		"SwordSwing2": preload("uid://c3eh7fshh2m0t"),
		"SwordSwing3": preload("uid://c3eh7fshh2m0t"),
		"AirAttack": preload("uid://c3eh7fshh2m0t"),
		"Climb": preload("uid://bj3fqpa35cwsk"),
		"SwordSoar": preload("uid://b2xek5bmcb4a"),
		"SwordSlam": preload("uid://bb8i6gvwgqsjy"),
		"DoubleCleave": preload("uid://cw87r1yvb8san")
	},
	"Bronze Fang Blade" : {
		"Idle": preload("uid://cnkd1sn66y2ev"),
		"Run": preload("uid://fp4qnilm8mem"),
		"Jump": preload("uid://cpnk8xcj1y2hf"),
		"Fall": preload("uid://kpxxp1e4knih"),
		"SwordSwing1": preload("uid://cl1aw31iwncip"),
		"SwordSwing2": preload("uid://cl1aw31iwncip"),
		"SwordSwing3": preload("uid://cl1aw31iwncip"),
		"AirAttack": preload("uid://cl1aw31iwncip"),
		"Climb": preload("uid://djnmym5xlblfi"),
		"SwordSoar": preload("uid://emq5do1fc44c"),
		"SwordSlam":preload("uid://5h15bet6jee3"),
		"DoubleCleave": preload("uid://bad3j5pey3k36")
	},
	"Iron Broad Sword" : {
		"Idle": preload("uid://dtvd0ax0xli76"),
		"Run": preload("uid://daposa1k2ace3"),
		"Jump": preload("uid://ddj71pwg2dyh0"),
		"Fall": preload("uid://dpx4qh3thvt12"),
		"SwordSwing1": preload("uid://bxray1pjmdjeu"),
		"SwordSwing2": preload("uid://bxray1pjmdjeu"),
		"SwordSwing3": preload("uid://bxray1pjmdjeu"),
		"AirAttack": preload("uid://j4del2xexl02"),
		"Climb": preload("uid://bcknti7tfmpnc"),
		"SwordSoar": preload("uid://j4del2xexl02"),
		"SwordSlam": preload("uid://c46m5505v4ljd"),
		"DoubleCleave": preload("uid://5ji20u66hw31")
	}
}

var pickaxe_textures : Dictionary = {
	"Stone Pickaxe": preload("uid://bu42xf7b1ykwj")
}

func get_sword_graphic(texture_name : String) -> Texture2D:
	var sword_index : int = int(PlayerStats.player_stats["Equipped Sword"])
	var sword_name : String = PlayerStats.get_sword(sword_index).sword_name
	return sword_textures[sword_name][texture_name]

func get_pickaxe_graphic() -> Texture2D:
	var pickaxe_name : String = PlayerStats.get_pickaxe_name() #gonna rework into a resource later
	return pickaxe_textures[pickaxe_name]
