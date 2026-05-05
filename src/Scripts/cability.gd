class_name Ability
extends Resource

@export_group("Meta Data")
@export var ability_name : String #Maybe this can be the "Animation Name" as well?
@export var class_relation : String
enum ABILITY_TYPE {STANDARD_ATTACK, AIR_ATTACK, DASH_ATTACK, DOUBLE_JUMP, SPECIAL_ATTACK, COMBAT_ABILITY_1, COMBAT_ABILITY_2, COMBAT_ABILITY_3, COMBAT_ABILITY_4}
@export var ability_type : ABILITY_TYPE = ABILITY_TYPE.STANDARD_ATTACK
@export var cooldown_time : float
@export_multiline var ability_description : String

@export_group("Behavior Resource")
@export var ability_behavior : AbilityBehavior

@export_group("Stat Modifier")
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
@export var knock_back_modifier : float

func get_ability_type_name() -> String:
	match ability_type:
		ABILITY_TYPE.AIR_ATTACK:
			return "Air Attack"
		ABILITY_TYPE.DASH_ATTACK:
			return "Dash Attack"
		ABILITY_TYPE.DOUBLE_JUMP:
			return "Double Jump"
		ABILITY_TYPE.SPECIAL_ATTACK:
			return "Special Attack"
		ABILITY_TYPE.COMBAT_ABILITY_1:
			return "Combat Ability 1"
		ABILITY_TYPE.COMBAT_ABILITY_2:
			return "Combat Ability 2"
		ABILITY_TYPE.COMBAT_ABILITY_3:
			return "Combat Ability 3"
		ABILITY_TYPE.COMBAT_ABILITY_4:
			return "Combat Ability 4"
		_:
			return ""

func load_stats() -> void:
	#print(SaveManager.current_save_game.abilities)
	#print(typeof(SaveManager.current_save_game.abilities))
	#print(class_relation)
	print(SaveManager.current_save_game.abilities[class_relation])
	print(typeof(SaveManager.current_save_game.abilities[class_relation]))
	print(SaveManager.current_save_game.abilities[class_relation][get_ability_type_name()])
	
	var ability = SaveManager.current_save_game.abilities[class_relation][get_ability_type_name()]
	var saved_ability : Dictionary = ability
	cooldown_time = saved_ability["Cooldown Time"]
	hp_cost = saved_ability["HP Cost"]
	mp_cost = saved_ability["MP Cost"]
	base_attack = saved_ability["Base Attack"]
	number_of_enemies_hit = saved_ability["Number of Enemies Hit"]
	max_hit_count = saved_ability["Max Hit Count"]
	healh_recovery_amount = saved_ability["Health Recovery"]
	mp_recover_amount = saved_ability["MP Recovery"]
	defense_modifier = saved_ability["Defense Modifier"]
	projectile_distance = saved_ability["Projectile Distance"]
	slow_wait_time = saved_ability["Slow Wait Time"]
	stun_wait_time = saved_ability["Stun Wait Time"]
	jump_height_modifier = saved_ability["Jump Height Modifier"]
	climb_speed_modifier = saved_ability["Climb Speed Modifier"]
	attack_damage_modifier = saved_ability["Attack Damage Modifier"]
	move_speed_modifier = saved_ability["Move Speed Modifier"]
	crit_damage_modifier = saved_ability["Crit Damage Modifier"]
	crit_chance_modifier = saved_ability["Crit Chance Modifier"]
	dash_cooldown_modifier = saved_ability["Dash Cooldown"]
	dash_speed_modifier = saved_ability["Dash Speed Modifier"]
	#knock_back_modifier = saved_ability["Knock Back Modifier"]
