class_name EnemyStun extends State

@export var idle : State
const ENEMY_STUN_BREAK = preload("uid://k4bl703t1udd")

func enter() -> void:
	super()
	parent.play_sfx(ENEMY_STUN_BREAK,-6)
	parent.disable_hit_box()
	parent.stun_timer.wait_time = PlayerStats.player_stats["Stun Length"]
	parent.stun_timer.start()

func exit() -> void:
	if !parent.is_dead:
		parent.enable_hit_box()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.stun_timer.time_left <= 0:
		parent.is_stunned = false
		return idle #might need to go to chase state?
	
	return null
		
