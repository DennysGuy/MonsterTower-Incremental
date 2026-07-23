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
@warning_ignore("unused_signal")
signal return_camera_to_player
@warning_ignore("unused_signal")
signal send_camera_to_market
@warning_ignore("unused_signal")
signal send_camera_to_cooking_station
@warning_ignore("unused_signal")
signal send_camera_to_smelting_station
@warning_ignore("unused_signal")
signal send_camera_to_sword_crafting_station
@warning_ignore("unused_signal")
signal stop_enemy_spawn
@warning_ignore("unused_signal")
signal start_enemy_spawn
@warning_ignore("unused_signal")
signal play_map_theme

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

func send_camera_to_player() -> void:
	return_camera_to_player.emit()

func disable_player_functionality() -> void:
	stop_player.emit()
	GameManager.player_can_move = false
	GameManager.player_can_attack = false
	GameManager.can_issue_abilities = false
	GameManager.can_open_bag = false
	GameManager.can_open_tower_map = false
	GameManager.can_pause_game = false
	GameManager.can_open_scene = false

func enable_player_functionality() -> void:
	GameManager.player_can_move = true
	GameManager.player_can_attack = true
	GameManager.can_issue_abilities = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	GameManager.can_pause_game = true
	GameManager.can_open_scene = true

func set_camera_to_player() -> void:
	set_camera_to_player_pos.emit()

func send_camera_to_market_pos() -> void:
	send_camera_to_market.emit()

func send_camera_to_smelting_station_pos() -> void:
	send_camera_to_smelting_station.emit()

func send_camera_to_cooking_station_pos() -> void:
	send_camera_to_cooking_station.emit()

func send_camera_to_sword_crafting_station_pos() -> void:
	send_camera_to_sword_crafting_station.emit()

func enable_enemy_spawn() -> void:
	start_enemy_spawn.emit()

func disable_enemy_spawn() -> void:
	stop_enemy_spawn.emit()

func play_map_theme_song() -> void:
	play_map_theme.emit()
