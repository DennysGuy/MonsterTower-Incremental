class_name LevelingTask extends Task

@export var level_needed : int


func check_level(level : int) -> void:
	if PlayerStats.player_stats["Level"] == level:
		completed = true
		QuestManager.play_task_completion_animation.emit(task_id,true)
		SaveManager.save_task_completed_status(task_id, completed)
		#save task

func build_task_list_item() -> TaskListItem:
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Reach Level %s" % level_needed
	new_task.task_data = self
	return new_task

func reset_task_state() -> void:
	SaveManager.current_save_game.tasks[task_id]["Completed"] = false
	SaveManager.save_game()
