class_name MapUnlockTask extends Task

@export var map_name : String

func check_map_name(selected_map_name : String) -> void:
	if selected_map_name != map_name or completed:
		return 
	
	completed = true
	QuestManager.play_task_completion_animation.emit(task_id,true)
	SaveManager.save_task_completed_status(task_id, completed)
	QuestManager.update_task_list_item.emit(task_id)


func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Enter %s" % map_name
	new_task.task_data = self
	return new_task
