class_name ClassAbilityNodeStats extends Resource

@export_group("Data")

@export var icon : Texture2D
@export var node_name : String
@export var needed_level : int 
@export var current_upgrade_level : int
@export var max_upgrade_level : int
@export var class_relation : String #name of the class
@export_multiline var description : String
@export var unlocked : bool = false
@export var ap_cost : int = 0
enum NODE_TYPE {ABILITY_UNLOCK, ABILITY_STAT_BOOST, CHARACTER_STAT_BOOST, CLASS_ADVANCE}
@export var node_type : NODE_TYPE
@export var materials_required : Array[Dictionary]

@export_group("Upgrades")

@export var ability_category : String
@export var ability_resource : Ability

@export_group("Ability Modifiers")
@export var cooldown_time : float
@export var hp_cost : float
@export var mp_cost : float
@export var base_attack : float
@export var number_of_enemies_hit : float #determines how many enemies can be hit in one attack
@export var max_hit_count : float #determines how many hits land per attack
@export var attack_rep_delay : float
@export var healh_recovery_amount : float
@export var mp_recover_amount : float
@export var defense_modifier : float
@export var projectile_distance : float
@export var slow_wait_time : float
@export var stun_wait_time : float
@export var jump_height_modifier : float
@export var climb_speed_modifier : float
@export var attack_damage_modifier : float
@export var move_speed_modifier : float
@export var crit_damage_modifier : float
@export var crit_chance_modifier : float
@export var dash_cooldown_modifier : float
@export var dash_speed_modifier : float
@export var hit_box_size_modifier : Vector2


@export_group("Character Stats Modifiers")
@export var attack_damage : float
@export var movement_speed_change : float
@export var climb_speed_change : float
@export var stun_length_change : float
@export var stun_stacks_change : float
@export var dash_speed_change : float
@export var dash_cooldown_change : float
@export var dash_duration_change : float
@export var invincibility_duration_change : float
@export var jump_height_change : float
@export var double_jump_height_change : float
@export var crit_chance_change : float
@export var defense_change : float
@export var crit_damage_change : float
@export var accuracy_change : float
@export var max_health_change : float
@export var max_mp_change : float


func get_ability_modifiers() -> Dictionary:
	return {
		"HP Cost": hp_cost,
		"MP Cost": mp_cost,
		"Base Attack": base_attack,
		"Enemies Hit": number_of_enemies_hit,
		"Max Hit Count": max_hit_count,
		"Attack Repeat Delay": attack_rep_delay,
		"Health Recovery": healh_recovery_amount,
		"MP Recovery": mp_recover_amount,
		"Defense": defense_modifier,
		"Projectile Distance": projectile_distance,
		"Slow Duration": slow_wait_time,
		"Stun Duration": stun_wait_time,
		"Jump Height": jump_height_modifier,
		"Climb Speed": climb_speed_modifier,
		"Attack Damage": attack_damage_modifier,
		"Move Speed": move_speed_modifier,
		"Crit Damage": crit_damage_modifier,
		"Crit Chance": crit_chance_modifier,
		"Dash Cooldown": dash_cooldown_modifier,
		"Dash Speed": dash_speed_modifier,
		"Hitbox Size": hit_box_size_modifier
	}

func get_character_stat_modifiers() -> Dictionary:
	return {
		"Attack Damage": attack_damage,
		"Movement Speed": movement_speed_change,
		"Climb Speed": climb_speed_change,
		"Stun Length": stun_length_change,
		"Stun Stacks": stun_stacks_change,
		"Dash Speed": dash_speed_change,
		"Dash Cooldown": dash_cooldown_change,
		"Dash Duration": dash_duration_change,
		"Invincibility Duration": invincibility_duration_change,
		"Jump Height": jump_height_change,
		"Double Jump Height": double_jump_height_change,
		"Crit Chance": crit_chance_change,
		"Defense": defense_change,
		"Crit Damage": crit_damage_change,
		"Accuracy": accuracy_change,
		"Max Health": max_health_change,
		"Max MP": max_mp_change
	}

func upgrade_ability_stats() -> void:
	var ability_stats : Dictionary = SaveManager.current_save_game.abilities[class_relation][ability_category]
	
	ability_stats["Cooldown Time"] += cooldown_time
	ability_stats["HP Cost"] += hp_cost
	ability_stats["MP Cost"] += mp_cost
	ability_stats["Base Attack"] += base_attack
	ability_stats["Number of Enemies Hit"] += number_of_enemies_hit
	ability_stats["Max Hit Count"] += max_hit_count
	ability_stats["Health Recovery"] += healh_recovery_amount
	ability_stats["MP Recovery"] += mp_recover_amount
	ability_stats["Defense Modifier"] += defense_modifier
	ability_stats["Projectile Distance"] += projectile_distance
	ability_stats["Slow Wait Time"] += slow_wait_time
	ability_stats["Stun Wait Time"] += stun_wait_time
	ability_stats["Jump Height Modifier"] += jump_height_modifier
	ability_stats["Climb Speed Modifier"] += climb_speed_modifier
	ability_stats["Attack Damage Modifier"] += attack_damage_modifier
	ability_stats["Move Speed Modifier"] += move_speed_modifier
	ability_stats["Crit Damage Modifier"] += crit_damage_modifier
	ability_stats["Crit Chance Modifier"] += crit_chance_modifier
	ability_stats["Dash Cooldown"] += dash_cooldown_modifier
	ability_stats["Dash Speed Modifier"] += dash_speed_modifier
	
	var equipped_abilities : Dictionary = PlayerStats.get_equipped_abilities()
	print(equipped_abilities[ability_category])
	equipped_abilities[ability_category].load_stats()
	SaveManager.save_equipped_abilities()
	SaveManager.save_game()

func upgrade_character_stats() -> void:
	PlayerStats.player_stats["Attack Damage"] += attack_damage
	PlayerStats.player_stats["Movement Speed"] += movement_speed_change
	PlayerStats.player_stats["Climbing Speed"] += climb_speed_change
	PlayerStats.player_stats["Stun Length"] += stun_length_change
	PlayerStats.player_stats["Stun Stacks"] += stun_stacks_change
	PlayerStats.player_stats["Dash Speed"] += dash_speed_change
	PlayerStats.player_stats["Dash Duration"] += dash_duration_change
	PlayerStats.player_stats["Dash Cooldown"] += dash_cooldown_change
	PlayerStats.player_stats["Invincibility Duration"] += invincibility_duration_change
	PlayerStats.player_stats["Jump Height"] += jump_height_change
	PlayerStats.player_stats["Double Jump Height"] += double_jump_height_change
	PlayerStats.player_stats["Crit Chance"] += crit_chance_change
	PlayerStats.player_stats["Defense"] += defense_change
	PlayerStats.player_stats["Crit Damage"] += crit_damage_change
	PlayerStats.player_stats["Accuracy"] += accuracy_change
	PlayerStats.player_stats["Max Health"] += max_health_change
	PlayerStats.player_stats["Max MP"] += max_mp_change
	
	SaveManager.save_player_stats()

func get_ability_type_name() -> String:
	match node_type:
		NODE_TYPE.ABILITY_UNLOCK:
			return "Ability Unlock"
		NODE_TYPE.ABILITY_STAT_BOOST:
			return "Ability Stat Boost"
		NODE_TYPE.CHARACTER_STAT_BOOST:
			return "Character Stat Boost"
		NODE_TYPE.CLASS_ADVANCE:
			return "Class Advancement"
		_:
			return ""
