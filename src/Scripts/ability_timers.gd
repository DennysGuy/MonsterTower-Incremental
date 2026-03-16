extends Node


@onready var dash_attack_timer: Timer = $DashAttackTimer
@onready var air_attack_timer: Timer = $AirAttackTimer
@onready var double_jump_timer: Timer = $DoubleJumpTimer
@onready var special_attack_timer: Timer = $SpecialAttackTimer

signal start_ability_cooldown_timer(ability_name)

@onready var ability_state : Dictionary = {
	"Dash Attack" : {"Can Do": true, "Timer": dash_attack_timer},
	"Air Attack":  {"Can Do": true, "Timer": air_attack_timer},
	"Double Jump":  {"Can Do": true, "Timer": double_jump_timer},
	"Special Attack":  {"Can Do": true, "Timer": special_attack_timer}
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
	
	ability_state[ability_name]["Timer"].wait_time = equipped_ability.cooldown_time
	start_ability_cooldown_timer.emit(ability_name)
	ability_state[ability_name]["Timer"].start()

func _on_dash_attack_timer_timeout() -> void:
	ability_state["Dash Attack"]["Can Do"] = true

func _on_air_attack_timer_timeout() -> void:
	ability_state["Air Attack"]["Can Do"] = true

func _on_double_jump_timer_timeout() -> void:
	ability_state["Double Jump"]["Can Do"] = true

func _on_special_attack_timer_timeout() -> void:
	ability_state["Special Attack"]["Can Do"] = true
