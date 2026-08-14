extends Node

var sword_textures : Dictionary = {
	"Stick": {
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
		"DoubleCleave": preload("uid://ubudq3lg48pa"),
		"CycloneSlash": preload("uid://c5b4p54lu8tqi"),
		"IronBody": preload("uid://cigmveocctl7m"),
		"CircleOfTruth" : preload("uid://dtcrlkchqxhe0"),
		"BasicDash" : preload("uid://d2bhjtp3erg2i"),
		"Weapon Crafted": preload("uid://cykc8jfijvab8"),
		"JumpFail": preload("uid://bjr8dvouteabr")
		
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
		"DoubleCleave": preload("uid://cw87r1yvb8san"),
		"CycloneSlash": preload("uid://dc1i7yvi7e0sm"),
		"IronBody": preload("uid://donx23cn8llnl"),
		"CircleOfTruth": preload("uid://bg0prb5vparob"),
		"BasicDash" : preload("uid://pxg4wsqdrd3d"),
		"Weapon Crafted": preload("uid://0xumhc3svd2s")
	},
	"Clopse Fang Blade" : {
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
		"DoubleCleave": preload("uid://bad3j5pey3k36"),
		"CycloneSlash": preload("uid://cd4w1t36y4pyw"),
		"IronBody": preload("uid://ct5gcpqihh32b"),
		"CircleOfTruth": preload("uid://ctcincrx7yf48"),
		"BasicDash": preload("uid://d3pwnhrwyilch"),
		"Weapon Crafted": preload("uid://clljhrjonsqlx"),
		"PiercerBall": preload("uid://miet442rgwjl"),
		"DoubleSlash": preload("uid://cgfqe6wff871x"),
		"ArcaneMine":  preload("uid://miet442rgwjl")
	},
	"Iron Broad Sword" : {
		"Idle": preload("uid://dtvd0ax0xli76"),
		"Run": preload("uid://daposa1k2ace3"),
		"Jump": preload("uid://ddj71pwg2dyh0"),
		"Fall": preload("uid://dpx4qh3thvt12"),
		"SwordSwing1": preload("uid://bxray1pjmdjeu"),
		"SwordSwing2": preload("uid://bxray1pjmdjeu"),
		"SwordSwing3": preload("uid://bxray1pjmdjeu"),
		"AirAttack": preload("uid://bxray1pjmdjeu"),
		"Climb": preload("uid://bcknti7tfmpnc"),
		"SwordSoar": preload("uid://j4del2xexl02"),
		"SwordSlam": preload("uid://c46m5505v4ljd"),
		"DoubleCleave": preload("uid://5ji20u66hw31"),
		"CycloneSlash": preload("uid://crgojonliiddi"),
		"IronBody": preload("uid://bjgbkqsoo5lu4"),
		"CircleOfTruth": preload("uid://wo2wr6ttll72"),
		"BasicDash": preload("uid://dbfg8xcnk7opf"),
		"Weapon Crafted": preload("uid://b1stjxo28qrk4")
	},
	"Lurker's Rapier" : {
		"Idle": preload("uid://cm80d7fsbve4o"),
		"Run": preload("uid://qikfrvmu45kq"),
		"Jump": preload("uid://csvpukvvdbs1w"),
		"Fall": preload("uid://7v3t7g3cptkq"),
		"SwordSwing1": preload("uid://dvs31aa3xa1ve"),
		"SwordSwing2": preload("uid://dvs31aa3xa1ve"),
		"SwordSwing3": preload("uid://dvs31aa3xa1ve"),
		"AirAttack":preload("uid://dvs31aa3xa1ve"),
		"Climb": preload("uid://o2ww0tdqcypg"),
		"SwordSoar": preload("uid://eowi25qc4fsw"),
		"SwordSlam": preload("uid://h3wsuchgnm5a"),
		"DoubleCleave": preload("uid://xken7iat8syv"),
		"CycloneSlash": preload("uid://xnrb5s450pht"),
		"IronBody": preload("uid://cwef1ias3oj1y"),
		"CircleOfTruth": preload("uid://2by3rjpuopj1"),
		"BasicDash": preload("uid://ddinrpgabivul"),
		"Weapon Crafted": preload("uid://bbcfsupt1odnt")
	},
	"Bronze Sword and Shield" : {
		"Idle": preload("uid://d5sy2hhicykr"),
		"Run": preload("uid://dp8tgmmslmuae"),
		"Jump": preload("uid://dq2mktptn2f10"),
		"Fall": preload("uid://2yv3p0jogi54"),
		"SwordSwing1": preload("uid://bjusjy5ayds6h"),
		"SwordSwing2": preload("uid://bjusjy5ayds6h"),
		"SwordSwing3": preload("uid://bjusjy5ayds6h"),
		"AirAttack":preload("uid://bjusjy5ayds6h"),
		"Climb": preload("uid://d2jrl07jnm6wo"),
		"SwordSoar": preload("uid://eowi25qc4fsw"),
		"SwordSlam": preload("uid://h3wsuchgnm5a"),
		"DoubleCleave": preload("uid://dkl2lmltud7tq"),
		"CycloneSlash": preload("uid://dbs6grhc4mxtn"),
		"IronBody": preload("uid://bxf10660k37s8"),
		"CircleOfTruth": preload("uid://nevk1iohux2"),
		"BasicDash": preload("uid://cwtljjmbafx03"),
		"Weapon Crafted": preload("uid://bf3mnbmhjo2ho")
	},
	"Standard Wand": {
		"Idle": preload("uid://bfd76yo68nwjp"),
		"Run": preload("uid://bburlkto74sfp"),
		"Jump": preload("uid://7qgkb2l8xmb0"),
		"Fall": preload("uid://dj1q0dg8ej5kt"),
		"SwordSwing1": preload("uid://cdbhi050amlxk"),
		"SwordSwing2": preload("uid://cdbhi050amlxk"),
		"AirAttack":preload("uid://cdbhi050amlxk"),
		"Climb": preload("uid://cch8u8dkgi3mf"),
		"BasicDash": preload("uid://cp7bhbiipdtae"),
		"Weapon Crafted": preload("uid://df1oe32ggcusc")
	},
	"Standard Staff": {
		"Idle": preload("uid://fwthk1u57bkr"),
		"Run": preload("uid://w20ljovdcr1g"),
		"Jump": preload("uid://bgg3ra7kubpg0"),
		"Fall": preload("uid://buy5vxmbfwlba"),
		"SwordSwing1": preload("uid://cjeiv7hihpag3"),
		"SwordSwing2":preload("uid://cjeiv7hihpag3"),
		"AirAttack": preload("uid://cjeiv7hihpag3"),
		"Climb": preload("uid://d251xvarfp6ww"),
		"BasicDash": preload("uid://diob0ejks0cy7"),
		"Weapon Crafted": preload("uid://ohjx1phm38td")
	}
}

var pickaxe_textures : Dictionary = {
	"Stone Pickaxe": preload("uid://bu42xf7b1ykwj")
}

func get_sword_graphic(texture_name : String) -> Texture2D:
	if PlayerStats.player_stats["Equipped Sword"] == -1:
		return null
	var sword_index : int = int(PlayerStats.player_stats["Equipped Sword"])
	var sword_name : String = PlayerStats.get_sword(sword_index).sword_name
	return sword_textures[sword_name][texture_name]

func get_pickaxe_graphic() -> Texture2D:
	var pickaxe_name : String = PlayerStats.get_pickaxe_name() #gonna rework into a resource later
	return pickaxe_textures[pickaxe_name]
