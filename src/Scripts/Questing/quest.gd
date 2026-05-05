class_name Quest extends Resource

@export var quest_title : String
@export var quest_id : int

enum QUEST_TYPE {MAIN, JOB}
@export var quest_type : QUEST_TYPE = QUEST_TYPE.MAIN

enum STATUS {LOCKED, AVAILABLE, IN_PROGRESS, TURN_IN, COMPLETED}
@export var status = STATUS.LOCKED

@export var level_needed : int
@export var turned_in : bool
@export_multiline var description : String
@export_multiline var turn_in_description : String
@export var chapter_relation : String
@export var quest_line : String
@export var next_quest : String
@export var quest_line_index : int
@export var tasks : Array[Task]
@export var cut_scene_path : String
@export var currency_reward : int = 0
@export var xp_reward : int = 0
@export var item_reward : Dictionary[Item, int]

func _init() -> void:
	pass

func set_as_available() -> void:
	status = STATUS.AVAILABLE
	SaveManager.save_quest_status(quest_id, status, turned_in)

func activate_quest() -> void:
	status = STATUS.IN_PROGRESS
	SaveManager.save_quest_status(quest_id, status, turned_in)

func unlock_quest() -> void:
	status = STATUS.AVAILABLE
	SaveManager.save_quest_status(quest_id, status, turned_in)

func ready_for_turn_in() -> void:
	status = STATUS.TURN_IN
	
	SaveManager.save_quest_status(quest_id, status, turned_in)

func complete_quest() -> void:
	status = STATUS.COMPLETED
	turned_in = true
	SaveManager.save_quest_status(quest_id, status, turned_in)

func is_locked() -> bool:
	return status == STATUS.LOCKED

func is_available() -> bool:
	return status == STATUS.AVAILABLE

func is_in_progress() -> bool:
	return status == STATUS.IN_PROGRESS

func is_ready_for_turn_in() -> bool:
	return status == STATUS.TURN_IN

func is_completed() -> bool:
	return status == STATUS.COMPLETED

func is_main_quest() -> bool:
	return quest_type == QUEST_TYPE.MAIN

func is_job() -> bool:
	return quest_type == QUEST_TYPE.JOB

func load_quest_status() -> void:
	status = SaveManager.current_save_game.quests[quest_id]["Status"]
	turned_in = SaveManager.current_save_game.quests[quest_id]["Turned In"]
