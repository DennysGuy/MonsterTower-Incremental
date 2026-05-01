class_name QuestTrackerItem extends MarginContainer

@export var quest_data : Quest
@export var checklist: VBoxContainer
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer

@export var quest_title: RichTextLabel
const QUEST_COMPLETED = preload("uid://om1y244uqbs")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestManager.check_for_quest_completion.connect(update_quest_completion)
	QuestManager.undo_quest_turn_in.connect(undo_quest_completion)
	quest_title.text = quest_data.quest_title
	build_task_list()
	if quest_data.is_job() and quest_data.is_ready_for_turn_in():
		var completed_text : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
		completed_text.label.text = "Ready For Turn In!"
		checklist.add_child(completed_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

'''
Use this function to build out the task list
TODO: Need to build task object
'''
func build_task_list() -> void:
	clear_checklist()
	for task in quest_data.tasks:
		task.parent_quest = quest_data.quest_title
		var new_task : TaskListItem = task.build_task_list_item()
		checklist.add_child(new_task)

func clear_checklist() -> void:
	for child in checklist.get_children():
		child.queue_free()

func update_quest_completion(quest_name : String) -> void:
	if !all_tasks_completed() or quest_name != quest_data.quest_title:
		return
	
	play_sfx(QUEST_COMPLETED)
	await get_tree().create_timer(1.5).timeout
	if quest_data.is_main_quest():
		quest_data.complete_quest()
		load_next_quest()
	else:
		var completed_text : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
		completed_text.label.text = "Ready For Turn In!"
		completed_text.is_turn_in_notice = true
		quest_data.ready_for_turn_in()
		checklist.add_child(completed_text)


func undo_quest_completion(quest_name : String) -> void:
	if quest_name != quest_data.quest_title or quest_data.is_in_progress():
		return
	
	for child in checklist.get_children():
		if child.is_turn_in_notice:
			child.queue_free()
	
	quest_data.activate_quest()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func all_tasks_completed() -> bool:
	for task in quest_data.tasks:
		if !task.completed:
			return false
	
	return true

func load_next_quest() -> void:
	if quest_data.next_quest == "END":
		var completed_text : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
		completed_text.label.text = "Quest Line Completed!"
		checklist.add_child(completed_text)
		return
	
	quest_data = QuestManager.get_quest(quest_data.next_quest)
	quest_data.activate_quest()
	QuestManager.swap_main_active_quest(quest_data)
	
	QuestManager.initial_main_quests.emit()

	#TODO: MY THOUGHT: FOR MAIN QUESTS AT END OF QUEST LINE WELL HAVE PLAYER EITHER
		#Go back to the hub for a cutscene or play a cutscene
