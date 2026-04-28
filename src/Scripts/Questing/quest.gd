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
@export var quest_line_index : int
@export var tasks : Array[Task]

func complete_quest() -> void:
	pass

func advance_quest_in_series() -> void:
	'''
	- when quest is completed we check if it is part of an existing questline
	- if so, we will:
		- if main line quest: automatically move the current main line quest to the next one (including animations necessary)
		- if job quest: we will unlock the next quest in series
		- if we hit the end of the quest series, we'll do something special maybe a cutscene or extra reward
	'''
	pass
