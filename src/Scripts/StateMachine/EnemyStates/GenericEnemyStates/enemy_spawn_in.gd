class_name EnemySpawnIn extends State

@export var idle_state : State

func enter() -> void:
	print("IVE SPAWNED!")
	parent.animation_player.play("SpawnIn")
	parent.disable_hurt_box()
	parent.disable_hit_box()
	parent.damageable = false
	parent.timer.wait_time = 1.0
	parent.timer.start()

func exit() -> void:
	parent.enable_hurt_box()
	parent.enable_hit_box()
	parent.damageable = true

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		return idle_state
	
	return null
