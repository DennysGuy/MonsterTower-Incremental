class_name MapUnlockTask extends Task

@export var map_name : String

func check_map_name(selected_map_name : String) -> void:
	if selected_map_name != map_name or completed:
		return 
	
	complete_task()

func connect_signals() -> void:
	if !QuestManager.check_map_name.connect(check_map_name):
		QuestManager.check_map_name.connect(check_map_name)

func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Enter %s" % map_name
	new_task.task_data = self
	return new_task
