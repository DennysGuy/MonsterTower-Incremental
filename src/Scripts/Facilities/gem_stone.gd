class_name GemStone extends Item


@export var socket_graphic : Texture2D
@export var tier : int = 1
@export var drop_rate : float
@export var flat_attack_bonus : float
@export var attack_percentage_bonus : float
@export var flat_defense_bonus : float
@export var defense_bonus : float
@export var max_hp_bonus : float
@export var max_mp_bonus : float
@export var accuracy_bonus : float
@export var stun_stacks_bonus : float
@export var status_duration_bonus : float
@export var crit_chance_bonus : float
@export var crit_damage_bonus : float
@export var attack_speed_bonus : float
@export var movement_speed_bonus : float
@export var jump_height_bonus : float
@export var climb_speed_bonus : float
@export var cool_down_bonus : float
@export var xp_bonus : float

#Perhaps we'll add elemental effects in the future

func get_stat_bonus_list() -> Dictionary:
	return {
		"Attack Bonus" : flat_attack_bonus,
		"Attack % Bonus" : attack_percentage_bonus,
		"Defense Bonus" : flat_defense_bonus,
		"Defense % Bonus" : defense_bonus,
		"Crit Chance Bonus" : crit_chance_bonus,
		"Crit Damage Bonus" : crit_damage_bonus,
		"Attack Speed Bonus" : attack_speed_bonus,
		"Movement Speed Bonus" : movement_speed_bonus,
		"Jump Height Bonus" : jump_height_bonus,
		"Climb Speed Bonus" : climb_speed_bonus,
		"Cool Down Bonus" : cool_down_bonus,
		"Status Duration Bonus" : status_duration_bonus,
		"Max HP Bonus" : max_hp_bonus,
		"Max MP Bonus" : max_mp_bonus,
		"Accuracy Bonus" : accuracy_bonus,
		"Stun Stacks Bonus": stun_stacks_bonus,
		"XP Bonus" : xp_bonus
	}

func get_stat_bonus(bonus_name : String) -> float:
	return get_stat_bonus_list()[bonus_name]
