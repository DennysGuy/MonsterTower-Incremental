extends Node

const SAVE_PATH : String = "user://game_save.tres"
var current_save_game : GameSave = null

func save_game() -> void:
	var result = ResourceSaver.save(current_save_game, SAVE_PATH)
	if result == OK:
		print("Game Saved!")
	else:
		print("There was a problem saveing the game...")

func create_new_save() -> void:
	var new_save : GameSave = GameSave.new()
	ResourceSaver.save(new_save,SAVE_PATH)
	await get_tree().process_frame
	current_save_game = get_existing_save_file()
	init_save_file()

func load_game() -> void:
	if save_file_exists():
		current_save_game = get_existing_save_file()
		init_save_file()
	else:
		var new_save_game : GameSave = GameSave.new()
		var result = ResourceSaver.save(new_save_game, SAVE_PATH)
		if result == OK:
			current_save_game = get_existing_save_file()
			print("Game Saved Successfully!")

func save_file_exists() -> bool:
	return ResourceLoader.exists(SAVE_PATH)

func init_save_file() -> void:
	PlayerStats.player_stats = current_save_game.player_stats
	PlayerStats.facilities_unlocked = current_save_game.facilities_unlocked
	PlayerStats.check_points_unlocked = current_save_game.check_points_unlocked
	PlayerStats.equipped_abilities = current_save_game.equipped_abilities
	
	InventoryManager.inventories = current_save_game.inventories
	TechTreeManager.currency = current_save_game.currency
	TechTreeManager.current_prestige = current_save_game.current_prestige
	TechTreeManager.current_upgrade_count = current_save_game.current_upgrade_count
	TechTreeManager.upgrade_count_to_prestige = current_save_game.upgrade_count_to_prestige
	load_equipped_abilities()
	load_gem_sockets()
	
func save_tech_tree_data() -> void:
	if current_save_game:
		current_save_game.currency = TechTreeManager.currency
		current_save_game.current_prestige = TechTreeManager.current_prestige
		current_save_game.upgrade_count_to_prestige = TechTreeManager.upgrade_count_to_prestige 
		current_save_game.current_upgrade_count = TechTreeManager.current_upgrade_count
		save_game()

func save_equipped_abilities() -> void:
	for ability in PlayerStats.get_equipped_abilities().keys():
		var save_game_ability = current_save_game.equipped_abilities[ability]
		if save_game_ability:
			save_game_ability = PlayerStats.get_equipped_ability(ability).resource_path
	
	save_game()

func save_equipped_gems_stones() -> void:
	for gem_stone in PlayerStats.get_equipped_gem_sockets().keys():
		var gem_socket = PlayerStats.get_gem_socket(gem_stone)
		if gem_socket:
			current_save_game.equipped_gem_sockets[gem_stone] = gem_socket.resource_path
		else:
			current_save_game.equipped_gem_sockets[gem_stone] = null
		
	save_game()

func save_player_stats() -> void:
	if current_save_game:
		current_save_game.player_stats = PlayerStats.player_stats
		current_save_game.facilities_unlocked = PlayerStats.facilities_unlocked
		save_game()

func save_inventories() -> void:
	if current_save_game:
		current_save_game.inventories = InventoryManager.inventories
		save_game()

func get_existing_save_file() -> GameSave:
	return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)

func load_equipped_abilities() -> void:
	for key in current_save_game.equipped_abilities.keys():
		var uid = current_save_game.equipped_abilities[key]
		if uid != null:
			if uid is String:
				PlayerStats.get_equipped_abilities()[key] = load(uid)
			else:
				PlayerStats.get_equipped_abilities()[key] = load(uid.resource_path)

func load_gem_sockets() -> void:
	for gem_socket in current_save_game.equipped_gem_sockets.keys():
		var uid = current_save_game.equipped_gem_sockets[gem_socket]
		if uid != null:
			if uid is String:
				PlayerStats.get_equipped_gem_sockets()[gem_socket] = load(uid)
			else:
				PlayerStats.get_equipped_gem_sockets()[gem_socket] = load(uid.resource_path)
