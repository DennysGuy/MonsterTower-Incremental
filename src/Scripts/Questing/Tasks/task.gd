class_name Task extends Resource

@export var task_id : int
@export var completed : bool = false
@export var parent_quest : String

enum TYPE {GATHERING, HUNTING, LEVELING, FACILITY_UNLOCK, MAP_UNLOCK, NODE_UNLOCK}
@export var task_type : TYPE = TYPE.GATHERING

func load_task_status() -> void:
	completed = SaveManager.current_save_game.tasks[task_id]["Completed"]

func reset_task_state() -> void:
	pass

func build_task_list_item() -> TaskListItem:
	'''
	- We will override this function in other child tasks to build a unique task
	'''
	return null

func connect_signals() -> void:
	pass

func complete_task() -> void:
	completed = true
	QuestManager.play_task_completion_animation.emit(task_id,true)
	SaveManager.save_task_completed_status(task_id, completed)
	QuestManager.update_task_list_item.emit(task_id)
	QuestManager.destroy_guide_box.emit(task_id)
	QuestManager.update_node_task_tracker.emit()
