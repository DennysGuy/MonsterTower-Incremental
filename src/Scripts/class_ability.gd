class_name ClassAbility extends Resource

@export_group("Meta Data")
@export var ability_name : String #Maybe this can be the "Animation Name" as well?
enum ABILITY_TYPE {STANDARD_ATTACK, AIR_ATTACK, DASH_ATTACK, SPECIAL_ATTACK}
@export var ability_type : ABILITY_TYPE = ABILITY_TYPE.STANDARD_ATTACK
@export_multiline var ability_description : String

@export_group("Behavior Resource")
@export var ability_behavior : AbilityBehavior

'''
- These Stats are upgraded by unlocking tech nodes in the 
Class progression tree
'''
@export_group("Stat Modifier")
@export var hp_cost : float
@export var mp_cost : float
@export var number_of_enemies_hit : float #determines how many enemies can be hit in one attack
@export var max_hit_count : float #determines how many hits land per attack
@export var healh_recovery_amount : float
@export var mp_recover_amount : float
@export var defense_modifier : float
@export var jump_height_modifier : float
@export var climb_speed_modifier : float
@export var attack_damage_modifier : float
@export var move_speed_modifier : float
@export var crit_damage_modifier : float
@export var crit_chance_modifier : float
@export var dash_cooldown_modifier : float
@export var hit_box_size_modifier : Vector2
