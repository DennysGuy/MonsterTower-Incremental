class_name Sword extends Resource

@export var sword_name : String
@export var index : int
enum ATTACK_SPEED {VERY_SLOW, SLOW, AVERAGE, FAST, VERY_FAST}
@export var attack_speed_type : ATTACK_SPEED = ATTACK_SPEED.AVERAGE

@export_multiline var description : String
@export var attack_bonus : float
@export var defense_bonus : float
@export var attack_speed : float
@export var crit_bonus : float
@export var hit_bonus : float
@export var multi_enemies_bonus : float
@export var crit_damage_bonus : float
@export var movement_speed_bonus : float
@export var status_duration_bonus : float
@export var accuracy_bonus : float
@export var climb_speed_bonus : float
@export var jump_height_bonus : float
@export var stun_stacks_bonus : float
@export var cool_down_bonus : float
@export var max_hp_bonus : float
@export var max_mp_bonus : float
@export var knock_back_bonus : float

@export var gem_stone_socket_count : int = 0
@export var recipe : CraftingRecipe

@export_group("Graphics")
@export var graphic : Texture2D
@export var mold_graphic : Texture2D
@export var menu_icon_graphic : Texture2D
@export var menu_icon_disabled_graphic : Texture2D

@export_group("Audio")
@export var swing_1 : AudioStream
@export var swing_2 : AudioStream
@export var swing_3 : AudioStream
@export var dash_attack : AudioStream

@export_group("Status")
@export var unlocked : bool = false
@export var is_tracked : bool = false

func get_stats_dict() -> Dictionary:
	return {
		"Attack Bonus": attack_bonus,
		"Attack Speed": attack_speed,
		"Defense Bonus": defense_bonus,
		"Crit Chance Bonus": crit_bonus,
		"Crit Damage Bonus": crit_damage_bonus,
		"Movement Speed Bonus": movement_speed_bonus,
		"Accuracy Bonus": accuracy_bonus,
		"Status Duration Bonus" : status_duration_bonus,
		"Climb Speed Bonus": climb_speed_bonus,
		"Jump Height Bonus" : jump_height_bonus,
		"Stun Stacks Bonus" : stun_stacks_bonus,
		"Cool Down Bonus": cool_down_bonus,
		"Max HP Bonus" : max_hp_bonus,
		"Max MP Bonus" : max_mp_bonus,
		"Multi Enemies Bonus": multi_enemies_bonus
		#"Knock Back Bonus" : knock_back_bonus
	}

func get_stats_description() -> String:
	var description : String = "Attack Speed: %s\n" % get_attack_speed_type()
	var stat_dictionary : Dictionary = get_stats_dict()
	for stat in stat_dictionary.keys():
		if stat == "Attack Speed":
			continue

		if stat_dictionary[stat] != 0.0:
			if stat_dictionary[stat] > 0:
				if stat_dictionary[stat] < 1.0:
					description += "%s: +%s \n" % [stat, int(stat_dictionary[stat]*100)] 
				else:
					description += "%s: +%s\n" % [stat, int(stat_dictionary[stat])]
			else:
				if stat_dictionary[stat] > -1.0:
					description += "%s: %s \n" % [stat, int(stat_dictionary[stat]*100)] 
				else:
					description += "%s: %s\n" % [stat, int(stat_dictionary[stat])]
	
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


func get_total_attack_bonus() -> float:
	return get_stats_dict()["Attack Bonus"] + PlayerStats.get_total_gem_attack_bonus()

func get_total_defense_bonus() -> float:
	return get_stats_dict()["Defense Bonus"] + PlayerStats.get_total_gem_defense_bonus()

func get_total_attack_speed_bonus() -> float:
	return get_stats_dict()["Attack Speed"] + PlayerStats.get_total_gem_bonus("Attack Speed")

func get_total_accuracy_bonus() -> float:
	return get_stats_dict()["Accuracy Bonus"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus")

func get_total_crit_chance_bonus() -> float:
	return get_stats_dict()["Crit Chance Bonus"] + PlayerStats.get_total_gem_bonus("Crit Chance Bonus")

func get_total_crit_damage_bonus() -> float:
	return get_stats_dict()["Crit Damage Bonus"] + PlayerStats.get_total_gem_bonus("Crit Damage Bonus")

func get_total_movement_speed_bonus() -> float:
	return get_stats_dict()["Movement Speed Bonus"] + PlayerStats.get_total_gem_bonus("Movement Speed Bonus")

func get_total_jump_height_bonus() -> float:
	return get_stats_dict()["Jump Height Bonus"] + PlayerStats.get_total_gem_bonus("Jump Height Bonus")

func get_total_climb_speed_bonus() -> float:
	return get_stats_dict()["Climb Speed Bonus"] + PlayerStats.get_total_gem_bonus("Climb Speed Bonus")
	
func get_total_status_duration_bonus() -> float:
	return get_stats_dict()["Status Duration Bonus"] + PlayerStats.get_total_gem_bonus("Status Duration Bonus")

func get_total_cool_down_bonus() -> float:
	return get_stats_dict()["Cool Down Bonus"] + PlayerStats.get_total_gem_bonus("Cool Down Bonus")

func get_total_hp_bonus() -> float:
	return get_stats_dict()["Max HP Bonus"] + PlayerStats.get_total_gem_bonus("Max HP Bonus")

func get_total_mp_bonus() -> float:
	return get_stats_dict()["Max MP Bonus"] + PlayerStats.get_total_gem_bonus("Max MP Bonus")

func get_total_stun_stacks_bonus() -> float:
	return get_stats_dict()["Stun Stacks Bonus"] + PlayerStats.get_total_gem_bonus("Stun Stacks Bonus")

func get_total_multi_enemies_bonus() -> float:
	return get_stats_dict()["Multi Enemies Bonus"] + PlayerStats.get_total_gem_bonus("Multi Enemies Bonus")

func get_attack_speed_type() -> String:
	match attack_speed_type:
		ATTACK_SPEED.VERY_SLOW:
			return "VERY SLOW"
		ATTACK_SPEED.SLOW:
			return "SLOW"
		ATTACK_SPEED.AVERAGE:
			return "AVERAGE"
		ATTACK_SPEED.FAST:
			return "FAST"
		ATTACK_SPEED.VERY_FAST:
			return "VERY FAST"
		_:
			return "AVERAGE"
