class_name HuntingTask extends Task

@export var enemy_to_hunt : EnemyStats
@export var number_to_get : int
@export var current_count : int


#need to load data upon game start up
func increment_count(enemy_name : String) -> void:
	if enemy_to_hunt.enemy_name != enemy_name:
		return
	current_count += 1
	if current_count >= number_to_get and !completed:
		QuestManager.play_task_completion_animation.emit(task_id)
		completed = true
		SaveManager.save_task_completed_status(task_id, completed)
	
	SaveManager.save_hunt_task_current_count(task_id, current_count)
	QuestManager.update_task_list_item.emit(task_id)
	#save task

func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Hunt %s: %s/%s" % [enemy_to_hunt.enemy_name, current_count, number_to_get]
	new_task.icon.texture = enemy_to_hunt.preview_icon
	new_task.task_data = self
	return new_task
