extends Node

const SAVE_PATH : String = "user://game_save.res"
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
	
	QuestManager.load_all_quest_status()
	QuestManager.load_active_quests()
	load_progression_states()
	load_equipped_abilities()
	PlayerStats.load_abilities()
	load_gem_sockets()

func save_floor_data(tower_entrance_data : TowerEntranceData, map_name : String) -> void:
	var saved_data = SaveManager.current_save_game
	saved_data.tower_entrance_data[tower_entrance_data.floor_name]["Number of Spawn Locations"] = tower_entrance_data.number_of_spawn_locations
	saved_data.tower_entrance_data[tower_entrance_data.floor_name]["Campfires Reached"] = tower_entrance_data.camp_fires_reached
	saved_data.tower_entrance_data[tower_entrance_data.floor_name]["Hunt Challenge Unlocked"] = tower_entrance_data.hunt_challenge_unlocked
	saved_data.tower_entrance_data[tower_entrance_data.floor_name]["Hunt Challenge Completed"] = tower_entrance_data.hunt_challenge_completed
	saved_data.check_points_unlocked[tower_entrance_data.floor_name] = PlayerStats.check_points_unlocked[tower_entrance_data.floor_name] 
	SaveManager.save_game()
	SaveManager.save_player_stats()

func save_tech_tree_data() -> void:
	if current_save_game:
		current_save_game.currency = TechTreeManager.currency
		current_save_game.current_prestige = TechTreeManager.current_prestige
		current_save_game.upgrade_count_to_prestige = TechTreeManager.upgrade_count_to_prestige 
		current_save_game.current_upgrade_count = TechTreeManager.current_upgrade_count
		save_game()

func load_progression_states() -> void:
	GameManager.first_class_just_unlocked = load_progression_state("First Class Just Unlocked")
	GameManager.first_quest_just_unlocked = load_progression_state("First Quest Just Unlocked")
	GameManager.market_intro_cutscene_played = load_progression_state("Market Intro Cutscene Played")
	GameManager.monster_voices_toggled = load_various_settings("Monster Voices Toggled")
	GameManager.job_selection_notice_scene_played = load_various_settings("Job Selection Notice Cutscene Played")

func save_equipped_abilities() -> void:
	for ability in PlayerStats.get_equipped_abilities().keys():
		var loaded_ability = PlayerStats.get_equipped_ability(ability)
		if loaded_ability:
			var save_game_ability = current_save_game.equipped_abilities[ability]
			save_game_ability = loaded_ability.resource_path
	
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

func save_hunt_task_current_count(task_id : int, count : int) -> void:
	if current_save_game:
		current_save_game.tasks[task_id]["Current Count"] = count
		save_game()

func save_task_completed_status(task_id : int, status : bool) -> void:
	if current_save_game:
		current_save_game.tasks[task_id]["Completed"] = status
		save_game()

func save_active_quests() -> void:
	if current_save_game:
		current_save_game.active_quests = QuestManager.active_quests
		save_game()

func save_quest_status(quest_id : int, status : int, turned_in : bool) -> void:
	current_save_game.quests[quest_id]["Status"] = status
	current_save_game.quests[quest_id]["Turned In"] = turned_in
	save_game()

func get_floor_entered_count(floor_name : String) -> int:
	return current_save_game.tower_entrance_data[floor_name]["Times Entered"] 

func save_floor_entered_count(floor_name : String, count : int) -> void:
	current_save_game.tower_entrance_data[floor_name]["Times Entered"] = count
	save_game()

func get_existing_save_file() -> GameSave:
	return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)

func save_weapon_unlocked_status(weapon_id : int, status: bool) -> void:
	current_save_game.weapon_status[weapon_id]["Unlocked"] = status
	save_game()

func save_weapon_tracked_status(weapon_id : int, status: bool) -> void:
	current_save_game.weapon_status[weapon_id]["Is Tracked"] = status
	save_game()

func get_weapon_unlocked_status(weapon_id : int) -> bool:
	return current_save_game.weapon_status[weapon_id]["Unlocked"]

func get_weapon_tracked_status(weapon_id : int) -> bool:
	return current_save_game.weapon_status[weapon_id]["Is Tracked"]

func get_floor_count(floor_name : String) -> int:
	return current_save_game.tower_entrance_data[floor_name]["Times Entered"]

func load_equipped_abilities() -> void:
	for key in current_save_game.equipped_abilities.keys():
		var uid = current_save_game.equipped_abilities[key]
		if uid != null:
			if uid is String:
				PlayerStats.get_equipped_abilities()[key] = load(uid)
				#PlayerStats.get_equipped_abilities()[key].load_stats()
			else:
				PlayerStats.get_equipped_abilities()[key] = load(uid.resource_path)
				#PlayerStats.get_equipped_abilities()[key].load_stats()

func load_gem_sockets() -> void:
	for gem_socket in current_save_game.equipped_gem_sockets.keys():
		var uid = current_save_game.equipped_gem_sockets[gem_socket]
		if uid != null:
			if uid is String:
				PlayerStats.get_equipped_gem_sockets()[gem_socket] = load(uid)
			else:
				PlayerStats.get_equipped_gem_sockets()[gem_socket] = load(uid.resource_path)

func save_monster_unlocks_status() -> void:
	current_save_game.monster_unlock_status = CodexManager.monster_unlock_status
	save_game()

func save_bar_unlocks_status() -> void:
	current_save_game.bar_recipe_unlocks = CodexManager.bar_recipe_unlocks
	save_game()

func save_dish_unlocks_status() -> void:
	current_save_game.dish_recipe_unlocks = CodexManager.dish_recipe_unlocks
	save_game()

func load_monster_unlocks_status() -> void:
	if not current_save_game:
		return
		
	CodexManager.monster_unlock_status = current_save_game.monster_unlock_status

func load_recipe_unlocks_status() -> void:
	if not current_save_game:
		return
	
	CodexManager.bar_recipe_unlocks = current_save_game.bar_recipe_unlocks
	CodexManager.dish_recipe_unlocks = current_save_game.dish_recipe_unlocks

func save_progression_state(state_name : String, state : bool) -> void:
	if current_save_game:
		current_save_game.progression_states[state_name] = state
		save_game()

func load_progression_state(state_name : String) -> bool:
	if current_save_game:
		return current_save_game.progression_states[state_name]
	
	return false	

func save_various_settings(setting : String, state : bool) -> void:
	if !current_save_game:
		var save_file = get_existing_save_file()
		if save_file:
			current_save_game = save_file
		return
		
	current_save_game.various_settings[setting] = state
	save_game()
	
func load_various_settings(setting : String) -> bool:
	return current_save_game.various_settings[setting]


func get_tech_node_stat_level(stat_name : String) -> int:
	return current_save_game.tech_nodes[stat_name]["Level"]
