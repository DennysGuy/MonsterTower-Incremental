class_name WarriorDoubleCleaveBehavior extends SpecialAttackBehavior


@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0
var attack_velocity : float = 0.0

@export var double_cleave_sfx : AudioStream

func on_enter(player : Player) -> void:
	parent = player
	parent.play_sfx(double_cleave_sfx,-2)
	parent.damageable = false

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
	parent.damageable = true

func apply_physics(_delta : float) -> State:
	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		attack_friction * _delta
	)

	parent.move_and_slide()

	return null
