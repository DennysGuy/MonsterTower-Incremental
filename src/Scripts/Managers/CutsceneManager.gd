extends Node


@warning_ignore("unused_signal")
signal trigger_next_image
@warning_ignore("unused_signal")
signal go_to_first_floor
@warning_ignore("unused_signal")
signal stop_player
@warning_ignore("unused_signal")
signal disable_close_function
@warning_ignore("unused_signal")
signal enable_close_function
@warning_ignore("unused_signal")
signal set_camera_to_player_pos
@warning_ignore("unused_signal")
signal set_camera_to_dojo_pos
@warning_ignore("unused_signal")
signal fly_boss_out

func trigger_next_frame() -> void:
	trigger_next_image.emit()

func to_first_floor() -> void:
	go_to_first_floor.emit()

func disable_close_button() -> void:
	disable_close_function.emit()

func enable_close_button() -> void:
	enable_close_function.emit()

func set_camera_to_dojo_position() -> void:
	set_camera_to_dojo_pos.emit()

func fly_boss() -> void:
	fly_boss_out.emit()

func disable_player_functionality() -> void:
	stop_player.emit()
	GameManager.player_can_move = false
	GameManager.player_can_attack = false
	GameManager.can_issue_abilities = false
	GameManager.can_open_bag = false
	GameManager.can_open_tower_map = false
	GameManager.can_pause_game = false

func enable_player_functionality() -> void:
	GameManager.player_can_move = true
	GameManager.player_can_attack = true
	GameManager.can_issue_abilities = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	GameManager.can_pause_game = true

func set_camera_to_player() -> void:
	set_camera_to_player_pos.emit()
