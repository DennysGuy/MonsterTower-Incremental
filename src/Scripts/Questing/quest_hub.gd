class_name QuestHub extends Control

@onready var main_line_quest_v_box: VBoxContainer = $QuestHubVBox/VBoxContainer/MainQuestListMargin/MainLineQuestVBox
@onready var job_tracker_v_box: VBoxContainer = $QuestHubVBox/JobsTracker/VBoxContainer/JobsListMargin/JobTrackerVBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#QuestManager.connect_active_main_quest_signals()
	QuestManager.initial_main_quests.connect(initialize_main_quests)
	QuestManager.initialize_job_quests.connect(initialize_job_quests)
	initialize_main_quests()
	initialize_job_quests()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initialize_main_quests() -> void:
	clear_quest_box(main_line_quest_v_box)
	var active_main_quests : Array = QuestManager.active_quests["Main"]
	for quest_name in active_main_quests:
		var selected_quest : Quest = QuestManager.get_quest(quest_name)
		var quest_tracker_item : QuestTrackerItem = preload("uid://bu2rhw7xf1a66").instantiate()
		if selected_quest:
			selected_quest.status = SaveManager.current_save_game.quests[selected_quest.quest_id]["Status"]
			quest_tracker_item.quest_data = selected_quest
			main_line_quest_v_box.add_child(quest_tracker_item)

func initialize_job_quests() -> void:
	clear_quest_box(job_tracker_v_box)
	var active_jobs : Array = QuestManager.active_quests["Job"]
	for quest_name in active_jobs:
		var selected_quest : Quest = QuestManager.get_quest(quest_name)
		var quest_tracker_item : QuestTrackerItem = preload("uid://bu2rhw7xf1a66").instantiate()
		if selected_quest:
			selected_quest.status = SaveManager.current_save_game.quests[selected_quest.quest_id]["Status"]
			quest_tracker_item.quest_data = selected_quest
			job_tracker_v_box.add_child(quest_tracker_item)
	
func clear_quest_box(v_box : VBoxContainer) -> void:
	for child in v_box.get_children():
		child.queue_free()
