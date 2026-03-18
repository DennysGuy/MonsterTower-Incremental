class_name Sword extends Resource

@export var sword_name : String
@export var attack_bonus : float
@export var defense_bonus : float
@export var attack_speed : float
@export var crit_bonus : float
@export var crit_damage_bonus : float
@export var movement_speed_bonus : float
@export var accuracy_bonus : float
@export var climb_speed_bonus : float
@export var stun_stacks_bonus : float
@export var cool_down_bonus : float
@export var max_hp_bonus : float
@export var max_mp_bonus : float

@export var gem_stone_socket_count : int = 0
@export var recipe : CraftingRecipe

@export_group("Graphics")
@export var graphic : Texture2D
@export var mold_graphic : Texture2D

@export_group("Audio")
@export var swing_1 : AudioStream
@export var swing_2 : AudioStream
@export var swing_3 : AudioStream
@export var dash_attack : AudioStream

func get_stats_dict() -> Dictionary:
	return {
		"Attack Bonus": attack_bonus,
		"Attack Speed": attack_speed,
		"Defense Bonus": defense_bonus,
		"Crit Chance Bonus": crit_bonus,
		"Crit Damage Bonus": crit_damage_bonus,
		"Movement Speed Bonus": movement_speed_bonus,
		"Accuracy Bonus": accuracy_bonus,
		"Climb Speed Bonus": climb_speed_bonus,
		"Stun Stacks Bonus" : stun_stacks_bonus,
		"Cool Down Bonus": cool_down_bonus,
		"Max HP Bonus" : max_hp_bonus,
		"Max MP Bonus" : max_mp_bonus
	}

func get_stats_description() -> String:
	var description : String = ""
	var stat_dictionary : Dictionary = get_stats_dict()
	for stat in stat_dictionary.keys():
		if stat_dictionary[stat] != 0.0:
			if stat_dictionary[stat] > 0:
				if stat_dictionary[stat] < 1.0:
					description += "%s: +%s \n" % [stat, stat_dictionary[stat]*100] 
				else:
					description += "%s: +%s\n" % [stat, stat_dictionary[stat]]
			else:
				if stat_dictionary[stat] > -1.0:
					description += "%s: -%s \n" % [stat, stat_dictionary[stat]*100] 
				else:
					description += "%s: -%s\n" % [stat, stat_dictionary[stat]]
	
	return description


func get_stats_gem_bonus_description() -> String:
	var description : String = ""
	var stat_dictionary : Dictionary = get_stats_dict()
	for stat in stat_dictionary.keys():

		if stat == "Attack Bonus":
			var total_attack_bonus : float = PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_total_gem_attack_bonus()
			description += "%s: %s (+%s)\n" % [stat, int(total_attack_bonus), int(PlayerStats.get_total_gem_attack_bonus())]
		elif stat == "Defense Bonus":
			var total_defense_bonus : float = PlayerStats.player_stats["Defense"] + PlayerStats.get_total_gem_defense_bonus()
			description += "%s: %s (+%s)\n" % [stat, int(total_defense_bonus), int(PlayerStats.get_total_gem_defense_bonus())]
		else:
			var total_gem_bonus : float = PlayerStats.get_total_gem_bonus(stat)
			var total_bonus : float = get_stats_dict()[stat] + total_gem_bonus
			description += "%s: %s (+%s)\n" % [stat, total_bonus, total_gem_bonus]
	
	return description
