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
signal play_task_completion_animation(task_id : int)
@warning_ignore("unused_signal")
signal play_undo_task_completion_animation(task_id : int)
@warning_ignore("unused_signal")
signal update_task_list_item(task_id : int)
@warning_ignore("unused_signal")
signal increment_task_enemy_kill_count(enemy_name : String)
@warning_ignore("unused_signal")
signal increment_task_item_gather_count(item_name : String)
@warning_ignore("unused_signal")
signal decrement_task_item_gather_count(item_name : String)
@warning_ignore("unused_signal")
signal check_for_quest_completion

var quests : Dictionary = {
	"Main": {
		"Introduction" : {
			"Shrubby's Hunt": preload("uid://56sc8x8gyyjy"),
			"The Mossy Womp": preload("uid://dra6tmjefibdy")
		}
	}
}

var quest_lines : Dictionary = {
	"Novice's Starter List" : false,
}


#func get_quest(quest_type : String, chapter_relation : String, quest_name : String ) -> Quest:
	#return quests[quest_type][chapter_relation][quest_name]
