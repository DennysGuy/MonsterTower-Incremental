extends Node


const SETTINGS_PATH : String = "user://settings.cfg"

enum WINDOW_MODE {
	WINDOWED,
	FULLSCREEN,
	BORDERLESS
}

const VIDEO_SECTION := "Video"

func set_window_mode(mode: WINDOW_MODE) -> void:
	match mode:
		WINDOW_MODE.WINDOWED:
			get_window().content_scale_size = Vector2i(1920, 1080)

			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

			await get_tree().process_frame

			DisplayServer.window_set_size(Vector2i(1280, 720))

			await get_tree().process_frame

			center_window()

		WINDOW_MODE.FULLSCREEN:
			get_window().content_scale_size = Vector2i(1920, 1080)

			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

		WINDOW_MODE.BORDERLESS:
			get_window().content_scale_size = Vector2i(1920, 1080)

			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

			await get_tree().process_frame

			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(DisplayServer.screen_get_size())
			DisplayServer.window_set_position(DisplayServer.screen_get_position())

func center_window() -> void:
	var screen_rect := DisplayServer.screen_get_usable_rect()
	var window_size := DisplayServer.window_get_size()

	DisplayServer.window_set_position(
		screen_rect.position + ((screen_rect.size - window_size) / 2)
	)


func is_windowed_mode() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED \
		and not DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)

func is_fullscreen_mode() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func is_borderless_mode() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED \
		and DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)

func save_window_mode(mode: WINDOW_MODE) -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)

	config.set_value(VIDEO_SECTION, "window_mode", mode)
	config.save(SETTINGS_PATH)

func load_window_mode() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)

	if err != OK:
		set_window_mode(WINDOW_MODE.WINDOWED)
		save_window_mode(WINDOW_MODE.WINDOWED)
		return

	var mode: int = config.get_value(VIDEO_SECTION, "window_mode", WINDOW_MODE.WINDOWED)
	set_window_mode(mode)

func set_default_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	
	#audio setup
	config.set_value("Audio", "Master", 0.0)
	config.set_value("Audio", "Music", -12.0)
	config.set_value("Audio", "SFX", -3.0)
	config.set_value("Audio", "Ambience", -5.0)

	config.save(SETTINGS_PATH)


func init_new_settings_config_file() -> void:
	set_default_settings()
	var saved_config_file : ConfigFile = get_settings_config_file()
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var ambience_bus = AudioServer.get_bus_index("Ambience")
	
	AudioServer.set_bus_volume_db(master_bus,saved_config_file.get_value("Audio", "Master"))
	AudioServer.set_bus_volume_db(music_bus,saved_config_file.get_value("Audio", "Music"))
	AudioServer.set_bus_volume_db(sfx_bus,saved_config_file.get_value("Audio", "SFX"))
	AudioServer.set_bus_volume_db(ambience_bus,saved_config_file.get_value("Audio", "Ambience"))

	save_controls(saved_config_file)
	load_controls(saved_config_file)
	#set_window_mode(WINDOW_MODE.BORDERLESS)

func get_settings_config_file() -> ConfigFile:
	var config_file : ConfigFile = ConfigFile.new()
	config_file.load(SETTINGS_PATH)
	return config_file

func save_audio_setting(bus : String, value : float) -> void:
	var config_file : ConfigFile = get_settings_config_file()
	var selected_bus : int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(selected_bus,value)
	config_file.set_value("Audio", bus, value)
	config_file.save(SETTINGS_PATH)

func get_audios_setting(bus : String) -> float:
	var config_file : ConfigFile = get_settings_config_file()
	return config_file.get_value("Audio", bus)

func load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	if err != OK:
		init_new_settings_config_file()
		return
	
	var saved_config_file : ConfigFile = get_settings_config_file()
	
	#set up audio settings
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var ambience_bus = AudioServer.get_bus_index("Ambience")
	
	
	AudioServer.set_bus_volume_db(master_bus,saved_config_file.get_value("Audio", "Master"))
	AudioServer.set_bus_volume_db(music_bus,saved_config_file.get_value("Audio", "Music"))
	AudioServer.set_bus_volume_db(sfx_bus,saved_config_file.get_value("Audio", "SFX"))
	AudioServer.set_bus_volume_db(ambience_bus,saved_config_file.get_value("Audio", "Ambience"))
	
	load_controls(saved_config_file)
	#load_window_mode()
		

func update_key_binding(action : String, event : InputEvent, new_event : InputEvent) -> void:
	InputMap.action_erase_event(action, event)
	InputMap.action_add_event(action, new_event)
	var saved_config_file : ConfigFile = get_settings_config_file()
	save_controls(saved_config_file)
	load_controls(saved_config_file)
	
func save_controls(config_file : ConfigFile) -> void:
	
	var actions = [
		"pan_cam_left", 
		"pan_cam_right",
		"pan_cam_up",
		"pan_cam_down",
		"add_currency",
		"dash_attack",
		"swing_sword",
		"interact",
		"open_bag",
		"close_menu",
		"combat_ability_1",
		"combat_ability_2",
		"combat_ability_3",
		"combat_ability_4",
		"open_codex",
		"open_player_stats",
		"open_recipe_book",
		"open_monsterpedia",
		"open_quests_log"
	]
	
	for action in actions:
		var events = InputMap.action_get_events(action)
	
		for event in events:
			if event is InputEventKey or event is InputEventMouseButton:
				config_file.set_value("Keyboard Bindings", action, event)

			elif event is InputEventJoypadButton:
				config_file.set_value("Controller Bindings",action, event)
	
	config_file.save(SETTINGS_PATH)
	
	
func load_controls(saved_config_file: ConfigFile) -> void:
	if not saved_config_file.has_section("Keyboard Bindings"):
		return
	
	var actions_to_clear: Array[String] = []
	
	for action in saved_config_file.get_section_keys("Keyboard Bindings"):
		actions_to_clear.append(action)
	
	if saved_config_file.has_section("Controller Bindings"):
		for action in saved_config_file.get_section_keys("Controller Bindings"):
			if not actions_to_clear.has(action):
				actions_to_clear.append(action)
	
	for action in actions_to_clear:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
	
	for action in saved_config_file.get_section_keys("Keyboard Bindings"):
		var event: InputEvent = saved_config_file.get_value("Keyboard Bindings", action)
		if InputMap.has_action(action):
			InputMap.action_add_event(action, event)
	
	if saved_config_file.has_section("Controller Bindings"):
		for action in saved_config_file.get_section_keys("Controller Bindings"):
			var event: InputEvent = saved_config_file.get_value("Controller Bindings", action)
			if InputMap.has_action(action):
				InputMap.action_add_event(action, event)
	
