class_name Sword extends Resource

@export var sword_name : String
@export var attack_bonus : float
@export var defense_bonus : float
@export var attack_speed : float
@export var crit_bonus : float
@export var crit_damage_bonus : float
@export var recipe : CraftingRecipe

func get_stats_dict() -> Dictionary:
	return {
		"Attack Bonus": attack_bonus,
		"Defense Bonus": defense_bonus,
		"Attack Speed": attack_speed,
		"Crit Chance Bonus": crit_bonus,
		"Crit Damage Bonus": crit_damage_bonus
	}

func get_stats_description() -> String:
	var description : String = ""
	var stat_dictionary : Dictionary = get_stats_dict()
	for stat in stat_dictionary.keys():
		if stat_dictionary[stat] > 0.0:
			if stat_dictionary[stat] < 1.0:
				description += "%s: +%s \n" % [stat, stat_dictionary[stat]*100] 
			else:
				description += "%s: +%s\n" % [stat, stat_dictionary[stat]] 
	
	return description
