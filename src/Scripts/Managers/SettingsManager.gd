extends Node


func set_default_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	
	#audio setup
	config.set_value("Audio", "Master", 0.0)
	config.set_value("Audio", "Music", -12.0)
	config.set_value("Audio", "SFX", -3.0)
	config.set_value("Audio", "Ambience", -5.0)

	config.save("user://settings.cfg")


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


func get_settings_config_file() -> ConfigFile:
	var config_file : ConfigFile = ConfigFile.new()
	config_file.load("user://settings.cfg")
	return config_file

func save_audio_setting(bus : String, value : float) -> void:
	var config_file : ConfigFile = get_settings_config_file()
	var selected_bus : int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(selected_bus,value)
	config_file.set_value("Audio", bus, value)
	config_file.save("user://settings.cfg")

func get_audios_setting(bus : String) -> float:
	var config_file : ConfigFile = get_settings_config_file()
	return config_file.get_value("Audio", bus)

func load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
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
		
