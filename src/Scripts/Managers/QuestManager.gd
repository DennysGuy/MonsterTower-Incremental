extends Node

@warning_ignore("unused_signal")
signal check_monster_count(monster_name : String)
@warning_ignore("unused_signal")
signal check_item_count(item_name : String)
@warning_ignore("unused_signal")
signal check_map_name(map_name : String)
@warning_ignore("unused_signal")
signal check_facility_name(facility_name : String)
@warning_ignore("unused_signal")
signal check_level
@warning_ignore("unused_signal")
signal play_task_completion_animation(task_id : int, check_for_quest_completion : bool)
@warning_ignore("unused_signal")
signal play_undo_task_completion_animation(task_id : int)
@warning_ignore("unused_signal")
signal update_task_list_item(task_id : int)
@warning_ignore("unused_signal")
signal increment_task_enemy_kill_count(enemy_name : String)
@warning_ignore("unused_signal")
signal increment_task_item_gather_count(item : Item)
@warning_ignore("unused_signal")
signal decrement_task_item_gather_count(item : Item)
@warning_ignore("unused_signal")
signal check_for_quest_completion(quest_title : String)
@warning_ignore("unused_signal")
signal initial_main_quests
@warning_ignore("unused_signal")
signal populate_job_board_description_box(quest : Quest)
@warning_ignore("unused_signal")
signal initialize_job_quests
@warning_ignore("unused_signal")
signal check_general_task_for_completion(task_name : String)
@warning_ignore("unused_signal")
signal undo_quest_turn_in(quest_title : String)
@warning_ignore("unused_signal")
signal check_node_name(selected_node_name : String)
@warning_ignore("unused_signal")
signal show_quest_complete_notice
@warning_ignore("unused_signal")
signal destroy_guide_box(task_id: int)
@warning_ignore("unused_signal")
signal recipe_objective_complete(recipe)
@warning_ignore("unused_signal")
signal weapon_tracker_updated
@warning_ignore("unused_signal")
signal update_node_task_tracker

@onready var quests : Dictionary = {
	"Main": {
		"Introduction" : {
			"A Fresh Embarking": preload("uid://c1xfvarhbakj7"),
			"Learning to Plunder": preload("uid://brnfkjbomxvxb"),
			"Getting Stronger": preload("uid://cp644y2y5gtor"),
			"Tip of the Iceberg": preload("uid://btd64g4acx31t"),
			"Finding a Profession": preload("uid://b2up70wcso64o"),
			"The Thick of It": preload("uid://iueqjhobrsol"),
			"A Mystery's Emergence": preload("uid://dp0x7ac3p4mkr"),
			"Context Evolution": preload("uid://bmshb0lx1qgxa")
		},
		"Spring" : {
			
		},
		"Fall" : {
			
		},
		"Winter" : {
			
		},
		"Summer" : {
			
		}
	},
	"Job": {
		"Introduction" : {
			"The Hunting Brave 1": preload("uid://bitrcpfq1fbrr"),
			"The Apprentice Chef 1": preload("uid://dbwmsoo2ddsgd"),
			"Supplies For Our Comrades 1": preload("uid://bpe3ga44k8076"),
			"The True Nature of the Tower 1": preload("uid://dhd0m6uxot38q"),
			"Avant Garde Alt. Medicine 1":preload("uid://1iraf0ury1mv")
		},
		"Spring" : {
			
		},
		"Fall" : {
			
		},
		"Winter" : {
			
		},
		"Summer" : {
			
		}
	}
}

@onready var active_quests : Dictionary = {
	"Main" : [
		"A Fresh Embarking"
	],
	"Job" : [
		
	]
}

var quest_lines : Dictionary = {
	"Novice's Starter List" : false,
}

func swap_main_active_quest(quest : Quest) -> void:
	var active_main_quest : Array = active_quests["Main"]
	active_main_quest.clear()
	active_main_quest.append(quest.quest_title)
	SaveManager.save_active_quests()
	#save active main quest

func get_active_main_quest() -> Quest:
	return get_quest(active_quests["Main"][0])
	
func get_quest(quest_name : String) -> Quest:
	var chapters : Array[String] = ["Introduction", "Spring", "Fall", "Winter"]
	var main_quests : Dictionary = quests["Main"]
	var job_quests : Dictionary = quests["Job"]
	
	var found_quest : Quest
	
	found_quest = search_quest(main_quests, chapters, quest_name)
				
	if !found_quest:
		found_quest = search_quest(job_quests, chapters, quest_name)
	
	return found_quest

func add_quest_to_active(quest : Quest) -> void:
	active_quests["Job"].append(quest.quest_title)
	SaveManager.save_active_quests()
	
	quest.activate_quest()

func remove_quest_from_active(quest : Quest, to_complete : bool) -> void:
	var list : Array = active_quests["Job"]
	
	if to_complete:
		quest.complete_quest()
	else:
		quest.set_as_available()
	
	list.erase(quest.quest_title)
		
	SaveManager.save_active_quests()

func search_quest(quest_dict : Dictionary, chapters : Array[String], quest_name : String) -> Quest:
	for chapter in chapters:
		for quest in quest_dict[chapter]:
			if quest_name == quest:
				return quest_dict[chapter][quest]
	return null

func load_all_quest_status() -> void:
	var chapters : Array[String] = ["Introduction", "Spring", "Fall", "Winter"]
	var main_quests : Dictionary = quests["Main"]
	var job_quests : Dictionary = quests["Job"]
	
	for chapter in chapters:
		for quest in main_quests[chapter]:
			if quest:
				var loaded_quest : Quest = get_quest(quest)
				if loaded_quest:
					loaded_quest.load_quest_status()
					connect_all_task_signals(loaded_quest)
	
	for chapter in chapters:
		for quest in job_quests[chapter]:
			if quest:
				var loaded_quest : Quest = get_quest(quest)
				if loaded_quest:
					loaded_quest.load_quest_status()

func check_for_available_job() -> bool:
	var chapters : Array[String] = ["Introduction", "Spring", "Fall", "Winter"]
	var job_quests : Dictionary = quests["Job"]
	
	for chapter in chapters:
		for quest in job_quests[chapter]:
			if quest:
				var loaded_quest : Quest = get_quest(quest)
				loaded_quest.load_quest_status()
				if loaded_quest.is_available():
					return true
	
	return false
	
func load_active_quests() -> void:
	if SaveManager.current_save_game:
		QuestManager.active_quests = SaveManager.current_save_game.active_quests
		
func activate_task(task : Task) -> void:
	if !task or !SaveManager.current_save_game:
		return
		
	if task is GatheringTask:
		if !increment_task_item_gather_count.connect(task.increment_count):
			increment_task_item_gather_count.connect(task.increment_count)
		if !decrement_task_item_gather_count.connect(task.decrement_count):
			decrement_task_item_gather_count.connect(task.decrement_count)
		QuestManager.increment_task_item_gather_count.emit(task.item_to_gather)
		
	elif task is HuntingTask:
		if !increment_task_enemy_kill_count.connect(task.increment_count):
			increment_task_enemy_kill_count.connect(task.increment_count)
		
		var saved_count : int = SaveManager.current_save_game.tasks[task.task_id]["Current Count"]
		task.current_count = saved_count
		
	elif task is LevelingTask:
		if !check_level.connect(task.check_level):
			check_level.connect(task.check_level)
		
		task.check_level()
	
	elif task is NodeUnlockTask:
		if !check_node_name.connect(task.check_node_name):
			check_node_name.connect(task.check_node_name)
	
	elif task is MapUnlockTask:
		if !check_map_name.connect(task.check_map_name):
			check_map_name.connect(task.check_map_name)
	
	elif task is EnterFacilityMenuTask:
		if !check_facility_name.connect(task.check_facility_name):
			check_facility_name.connect(task.check_facility_name)

	elif task is GeneralTask:
		if !check_general_task_for_completion.connect(task.complete_general_task):
			check_general_task_for_completion.connect(task.complete_general_task)
	
	task.completed = SaveManager.current_save_game.tasks[task.task_id]["Completed"]

func connect_all_task_signals(quest : Quest) -> void:
	if quest.is_completed():
		return
		
	for task in quest.tasks:
		task.connect_signals()
		print("Signals Connected!")

#func get_quest(quest_type : String, chapter_relation : String, quest_name : String ) -> Quest:
	#return quests[quest_type][chapter_relation][quest_name]
