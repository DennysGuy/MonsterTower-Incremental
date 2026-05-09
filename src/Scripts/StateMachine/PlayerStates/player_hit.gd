class_name PlayerHitState extends State

@export var wait_time : float
@export var invincibility_time : float
@export var idle_state : State
@export var attack_1_state : State
@export var hit_sfx : AudioStream

var knock_back_direction : int
func enter() -> void:
	super()
	if parent.stored_enemy:
		GameManager.player_can_move = false
		#parent.damageable = false
		parent.disable_hurt_box()
		parent.set_sword_texture(animation_name)
		parent.set_outfit_texture(animation_name)
		var total_knock_back : float = (parent.knock_back_wait_time * PlayerStats.knock_back_buff_mod)
		print(PlayerStats.knock_back_buff_mod)
		parent.timer.wait_time = total_knock_back

		var dir = (parent.stored_enemy.global_position - parent.global_position).normalized()
		knock_back_direction = GameManager.set_direction(dir.x) * -1
		parent.sfx_player.play_sfx(hit_sfx)
		parent.timer.start()
		#SignalBus.disable_enemy_hit_box.emit()
		SignalBus.shake_camera.emit(3)
		HitStopManager.freeze(0.06, 0.0)
		parent.start_invincibility()

func exit() -> void:
	parent.velocity = Vector2.ZERO
	GameManager.player_can_move = true
	parent.stored_enemy = null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.can_knock_back:
		parent.velocity.x = knock_back_direction * PlayerStats.KNOCKBACK_FORCE
		parent.flip_textures(!(parent.velocity.x < 0))
		if parent.timer.time_left <= 0:
			if Input.is_action_pressed("swing_sword"):
				return attack_1_state
			return idle_state
	
		parent.move_and_slide()
	else:
		return idle_state	
	
	return null
		
