class_name SwordSlamBehavior extends AirAttackBehavior

@export var soar_sfx : AudioStream
@export var slam_sfx : AudioStream

func on_enter(player : Player) -> void:
	
	parent = player
	parent.damageable = false
	parent.velocity = Vector2.ZERO
	parent.play_sfx(soar_sfx,-8)

func apply_physics(_delta : float) -> State:
	parent.velocity.y += 150
	
	return null

func on_landing() -> State:
	#send out waves
	var left_shock_wave : SwordSlamShockWave = preload("uid://d2l513up1bout").instantiate()
	left_shock_wave.flip_direction()
	left_shock_wave.global_position = Vector2(parent.global_position.x-20, parent.global_position.y)
	
	var right_shock_wave : SwordSlamShockWave = preload("uid://d2l513up1bout").instantiate()
	right_shock_wave.global_position = Vector2(parent.global_position.x+20, parent.global_position.y)
	
	parent.get_parent().add_child(left_shock_wave)
	parent.get_parent().add_child(right_shock_wave)
	
	parent.play_sfx(slam_sfx,-8)
	SignalBus.shake_camera.emit(2)
	HitStopManager.freeze(0.1,0.3)
	parent.damageable = true
	return parent.idle_state
