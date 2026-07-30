class_name PlayerPunch extends State

var attack_velocity : float = 0.0

var can_attack_cancel : bool = false

func enter() -> void:
	animation_name = "Punch"
	parent.animation_player.play(animation_name)

	parent.set_sword_texture("SwordSwing1")
	parent.effect.texture = OutfitGraphics.get_outfit_graphic("BasicAttackEffect")
	parent.set_outfit_texture(animation_name)
	
	parent.timer.wait_time = PlayerStats.get_current_sword().get_total_attack_speed_bonus()
	parent.timer.start()
	
	if parent.knocked_back:
		parent.stop_player()
	else:
		# --- CAPTURE MOMENTUM ---
		if int(parent.velocity.x) != 0:
			attack_velocity = parent.velocity.x
			attack_velocity = clamp(
				attack_velocity,
				-parent.max_attack_drift,
				parent.max_attack_drift
			)

			parent.velocity.x = attack_velocity

	# Clamp so sprint/dash doesn't slide forever
	#parent.sfx_player.play_sfx(swing, 3.0)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
