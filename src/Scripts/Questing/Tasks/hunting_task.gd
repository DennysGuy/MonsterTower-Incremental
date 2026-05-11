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
		QuestManager.play_task_completion_animation.emit(task_id,true)
		completed = true
		SaveManager.save_task_completed_status(task_id, completed)
	
	SaveManager.save_hunt_task_current_count(task_id, current_count)
	QuestManager.update_task_list_item.emit(task_id)
	#save task

func connect_signals() -> void:
	if !QuestManager.increment_task_enemy_kill_count.connect(increment_count):
		QuestManager.increment_task_enemy_kill_count.connect(increment_count)

func reset_task_state() -> void:
	current_count = 0
	SaveManager.current_save_game.tasks[task_id]["Current Count"] = 0
	SaveManager.current_save_game.tasks[task_id]["Completed"] = false
	SaveManager.save_game()

func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	current_count = SaveManager.current_save_game.tasks[task_id]["Current Count"]
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Hunt %s: %s/%s" % [enemy_to_hunt.enemy_name, current_count, number_to_get]
	new_task.icon.texture = enemy_to_hunt.preview_icon
	new_task.task_data = self
	return new_task
