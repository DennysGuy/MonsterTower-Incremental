class_name PlayerDashAttackState extends State

@export var idle_state : State
@export var duration : float
@export var dash_sfx : AudioStream
func enter() -> void:
	super()
	parent.set_sword_texture(animation_name)
	parent.timer.wait_time = duration
	parent.timer.start()
	parent.dash_attack_collision_shape.disabled = false
	parent.damageable = false

	var swing : AudioStream = PlayerStats.get_sword(int(PlayerStats.player_stats["Equipped Sword"])).swing_3
	parent.sfx_player.play_sfx(swing,3.0)

func exit() -> void:
	parent.velocity = Vector2.ZERO
	parent.dash_attack_collision_shape.disabled = true
	parent.damageable = true
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	parent.issue_attack(parent.dash_attack_hit_box)
	if parent.timer.time_left <= 0:
		return idle_state
	
	parent.velocity.x = PlayerStats.player_stats["Dash Speed"] * GameManager.set_player_box_direction(parent.sprite.flip_h)
	parent.move_and_slide()
	return null
