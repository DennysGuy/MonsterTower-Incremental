class_name NodeUnlockTask extends Task

@export var node_name : String


func check_node_name(selected_node_name : String) -> void:
	if selected_node_name != node_name or completed:
		return 
	
	completed = true
	QuestManager.play_task_completion_animation.emit(task_id,true)
	SaveManager.save_task_completed_status(task_id, completed)
	QuestManager.update_task_list_item.emit(task_id)


func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Unlock %s Node" % node_name
	new_task.task_data = self
	return new_task
