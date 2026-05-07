class_name CycloneSlash extends CombatAbilityBehavior

@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0
var attack_velocity : float = 0.0


func on_enter(player : Player) -> void:
	parent = player
	parent.damageable = false
	parent.disable_hurt_box()
	parent.play_sfx(sfx)
# --- CAPTURE MOMENTUM ---
	if int(parent.velocity.x) != 0:
		attack_velocity = parent.velocity.x
		attack_velocity = clamp(
			attack_velocity,
			-max_attack_drift,
			max_attack_drift
		)

		parent.velocity.x = attack_velocity

func on_exit() -> void:
	parent.enable_hurt_box()
	

func apply_physics(_delta : float) -> State:
	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		attack_friction * _delta
	)

	parent.move_and_slide()

	return null
