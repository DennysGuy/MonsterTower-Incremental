class_name LevelingTask extends Task

@export var level_needed : int


func check_level() -> void:
	if PlayerStats.player_stats["Level"] >= level_needed:
		complete_task()
		#save task

func connect_signals() -> void:
	if !QuestManager.check_level.connect(check_level):
		QuestManager.check_level.connect(check_level)

func build_task_list_item() -> TaskListItem:
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Reach Level %s" % level_needed
	new_task.task_data = self
	return new_task

func reset_task_state() -> void:
	SaveManager.current_save_game.tasks[task_id]["Completed"] = false
	SaveManager.save_game()
