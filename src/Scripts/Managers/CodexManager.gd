extends Node
class_name CodexManagerScript

signal populate_monster_description_panel(monster_stats : EnemyStats)

const WILLOW_SHRUB = preload("uid://e6ejdj1jwoj0")
const CORRUPTED_MUSHIE = preload("uid://bq0juubwkp8im")
const CORRUPTED_MUSHIE_LV_L_2 = preload("uid://dwtw24hgj7tub")
const BATCLOPSE = preload("uid://dsl20riisg4mk")
const BATCLOPSE_LVL_2 = preload("uid://d4h3fsu5cbkti")
const MOSS_GOLEM = preload("uid://dwook5wtmbf8g")
const BEETLE_KNIGHT = preload("uid://bq77ocfjc35gc")
const BEETLE_KNIGHT_LVL_2 = preload("uid://6q2nq8bgf2bm")
const SERPANT_MIMIC = preload("uid://0y733wkj0ion")
const SERPANT_MIMIC_LVL_2 = preload("uid://du4so306s4lte")
const GOBLIN_THIEF = preload("uid://cq7q6npjlayh1")
const ORC_WARLORD = preload("uid://cnwbnpkxv6bpd")


var monster_list : Array[EnemyStats]= [
	
	WILLOW_SHRUB,
	CORRUPTED_MUSHIE,
	CORRUPTED_MUSHIE_LV_L_2,
	BATCLOPSE,
	BATCLOPSE_LVL_2,
	MOSS_GOLEM,
	BEETLE_KNIGHT,
	BEETLE_KNIGHT_LVL_2,
	SERPANT_MIMIC,
	SERPANT_MIMIC_LVL_2,
	GOBLIN_THIEF,
	ORC_WARLORD
]
