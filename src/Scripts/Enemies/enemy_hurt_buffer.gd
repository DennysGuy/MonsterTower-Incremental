class_name EnemyHurtBuffer extends State

@export var idle_state : State
@export var chase_state : State

@export var buffer_time : float = 0.18

func enter() -> void:
	parent.timer.wait_time = buffer_time
	parent.timer.start()

func exit() -> void:
	if !parent.is_silenced:
		parent.enable_hit_box()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		if parent.enemy_stats.is_passive():
			return idle_state
		else:
			return chase_state
	return null
