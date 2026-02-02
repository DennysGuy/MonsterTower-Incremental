extends Node

const SAVE_PATH : String = "user://game_save.res"
var current_save_game : GameSave = null

func save_game() -> void:
	pass

func load_game() -> void:
	if save_file_exists():
		current_save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	
	else:
		var new_save_game : GameSave = GameSave.new()
		var result = ResourceSaver.save(new_save_game, SAVE_PATH)
		if result :
			print("Game Saved Successfully!")
		else:
			print(result)
			print("SOMETHING HAPPENED!")

func save_file_exists() -> bool:
	return ResourceLoader.exists(SAVE_PATH)
