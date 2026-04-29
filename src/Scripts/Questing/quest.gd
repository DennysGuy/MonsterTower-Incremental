class_name Quest extends Resource

@export var quest_title : String
@export var quest_id : int

enum QUEST_TYPE {MAIN, JOB}
@export var quest_type : QUEST_TYPE = QUEST_TYPE.MAIN

enum STATUS {LOCKED, AVAILABLE, IN_PROGRESS, COMPLETED}
@export var status = STATUS.LOCKED

@export var level_needed : int
@export_multiline var description : String
@export var chapter_relation : String
@export var quest_line : String
@export var next_quest : String
@export var quest_line_index : int
@export var tasks : Array[Task]

func _init() -> void:
	pass

func activate_quest() -> void:
	status = STATUS.IN_PROGRESS
	SaveManager.save_quest_status(quest_id, status)

func unlock_quest() -> void:
	status = STATUS.AVAILABLE
	SaveManager.save_quest_status(quest_id, status)

func complete_quest() -> void:
	status = STATUS.COMPLETED
	SaveManager.save_quest_status(quest_id, status)

func is_main_quest() -> bool:
	return quest_type == QUEST_TYPE.MAIN

func is_job() -> bool:
	return quest_type == QUEST_TYPE.JOB

func load_quest_status() -> void:
	status = SaveManager.current_save_game.quests[quest_id]["Status"]
