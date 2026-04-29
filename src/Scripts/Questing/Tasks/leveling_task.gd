class_name LevelingTask extends Task

@export var level_needed : int

func _init() -> void:
	QuestManager.check_level.connect(check_level)

func check_level(level : int) -> void:
	if PlayerStats.player_stats["Level"] == level:
		completed = true
		QuestManager.play_task_completion_animation.emit(task_id)
		SaveManager.save_task_completed_status(task_id, completed)
		#save task

func build_task_list_item() -> TaskListItem:
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Reach Level %s" % level_needed
	new_task.task_data = self
	return new_task
