extends Node


@onready var dash_attack_timer: Timer = $DashAttackTimer
@onready var air_attack_timer: Timer = $AirAttackTimer
@onready var double_jump_timer: Timer = $DoubleJumpTimer
@onready var special_attack_timer: Timer = $SpecialAttackTimer
@onready var combat_ability_timer_1: Timer = $CombatAbilityTimer1
@onready var combat_ability_timer_2: Timer = $CombatAbilityTimer2
@onready var combat_ability_timer_3: Timer = $CombatAbilityTimer3
@onready var combat_ability_timer_4: Timer = $CombatAbilityTimer4
@onready var buff_timer_1: Timer = $BuffTimer1

signal start_ability_cooldown_timer(ability_name)

@onready var ability_state : Dictionary = {
	"Dash" : {"Can Do": true, "Timer": dash_attack_timer},
	"Air Attack":  {"Can Do": true, "Timer": air_attack_timer},
	"Double Jump":  {"Can Do": true, "Timer": double_jump_timer},
	"Special Attack":  {"Can Do": true, "Timer": special_attack_timer},
	"Combat Ability 1": {"Can Do": true, "Timer": combat_ability_timer_1},
	"Combat Ability 2": {"Can Do": true, "Timer": combat_ability_timer_2},
	"Combat Ability 3": {"Can Do": true, "Timer": combat_ability_timer_3},
	"Combat Ability 4": {"Can Do": true, "Timer": combat_ability_timer_4},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_ability_cooldown(ability_name : String) -> void:
	ability_state[ability_name]["Can Do"] = false
	var equipped_ability = PlayerStats.equipped_abilities[ability_name]
	
	if equipped_ability is String:
		equipped_ability = load(equipped_ability)
	
	var cooldown_bonus : float = PlayerStats.player_stats["Cooldown Reduction"]
	var total_cooldown : float = max(0, equipped_ability.cooldown_time - cooldown_bonus)

	var ability_timer : Timer = ability_state[ability_name]["Timer"]
	
	if !equipped_ability.is_combat_ability:
		ability_timer.wait_time = equipped_ability.cooldown_time
	else:
		ability_timer.wait_time = total_cooldown
		
	start_ability_cooldown_timer.emit(ability_name)
	
	ability_timer.start()

func start_buff_timer_1(wait_time : float, ability : Ability) -> void:
	
	buff_timer_1.wait_time = wait_time
	PlayerHudSignalBus.add_buff_activated_icon.emit(buff_timer_1, ability)
	buff_timer_1.start()
	

func _on_dash_attack_timer_timeout() -> void:
	ability_state["Dash"]["Can Do"] = true

func _on_air_attack_timer_timeout() -> void:
	ability_state["Air Attack"]["Can Do"] = true

func _on_double_jump_timer_timeout() -> void:
	ability_state["Double Jump"]["Can Do"] = true

func _on_special_attack_timer_timeout() -> void:
	ability_state["Special Attack"]["Can Do"] = true

func _on_combat_ability_timer_1_timeout() -> void:
	ability_state["Combat Ability 1"]["Can Do"] = true

func _on_combat_ability_timer_2_timeout() -> void:
	ability_state["Combat Ability 2"]["Can Do"] = true

func _on_combat_ability_timer_3_timeout() -> void:
	ability_state["Combat Ability 3"]["Can Do"] = true

func _on_combat_ability_timer_4_timeout() -> void:
	ability_state["Combat Ability 4"]["Can Do"] = true

func _on_buff_timer_1_timeout() -> void:
	#this is might have to change - there probably won't be more than
	#1 stat buff abilities available at a given time though
	#will need to remove the corresponding hud icon
	PlayerStats.reset_global_stat_buffs()
	GameManager.mp_siphon_activated = false
