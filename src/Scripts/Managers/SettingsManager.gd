extends Node


const SETTINGS_PATH : String = "user://settings.cfg"

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
				config_file.set_value("Controller Bindings",action, events[1])
	
	config_file.save(SETTINGS_PATH)
	
	
func load_controls(saved_config_file : ConfigFile) -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	# If the file doesn't exist yet, just exit
	if err != OK:
		return
	
	for action in saved_config_file.get_section_keys("Keyboard Bindings"):
		var event = saved_config_file.get_value("Keyboard Bindings", action)
		
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
	
