class_name GeneralTask extends Task

@export var task_name : String
@export var task_description : String

func complete_general_task(selected_task_name : String) -> void:
	if selected_task_name != task_name or completed:
		return 
	
	completed = true
	QuestManager.play_task_completion_animation.emit(task_id,true)
	SaveManager.save_task_completed_status(task_id, completed)
	QuestManager.update_task_list_item.emit(task_id)


func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = task_description
	new_task.task_data = self
	return new_task
