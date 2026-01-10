class_name EnemyDead extends State

@export var wait_time : float

func enter() -> void:
	super()
	if parent.hit_box:
		parent.hit_box.get_child(0).disabled = true
	
	HitStopManager.freeze(0.15)
	parent.damageable = false
	parent.is_dead = true
	parent.health_bar.hide()
	parent.timer.wait_time = wait_time
	parent.timer.start()
	parent.start_fadeout()
	
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		pass
		
	return null
