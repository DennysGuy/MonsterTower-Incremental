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
signal undo_quest_turn_in(quest_title : String)

@onready var quests : Dictionary = {
	"Main": {
		"Introduction" : {
		},
		"Spring" : {
			
		},
		"Fall" : {
			
		},
		"Winter" : {
			
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
			
		}
	}
}

@onready var active_quests : Dictionary = {
	"Main" : [
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
	
	if list.size() == 1:
		list.remove_at(0)
	else:
		for i in range(list.size()-1):
			if list[i] == quest.quest_title:
				list.remove_at(i)
		
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
	
	for chapter in chapters:
		for quest in job_quests[chapter]:
			if quest:
				var loaded_quest : Quest = get_quest(quest)
				if loaded_quest:
					loaded_quest.load_quest_status()

func load_active_quests() -> void:
	if SaveManager.current_save_game:
		QuestManager.active_quests = SaveManager.current_save_game.active_quests

func activate_task(task : Task) -> void:
	if !task:
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
	
	task.completed = SaveManager.current_save_game.tasks[task.task_id]["Completed"]

#func get_quest(quest_type : String, chapter_relation : String, quest_name : String ) -> Quest:
	#return quests[quest_type][chapter_relation][quest_name]
