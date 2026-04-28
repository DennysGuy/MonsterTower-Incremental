class_name GatheringTask extends Task

@export var item_to_gather : Item
@export var number_to_get : int
@export var current_count : int

func _init() -> void:
	QuestManager.increment_task_item_gather_count.connect(increment_count)
	QuestManager.decrement_task_item_gather_count.connect(decrement_count)
	#we'll need to check at some point upon start up if the player already has sufficient item count

#need to load data upon game start up
func increment_count(item_name : String) -> void:
	if item_to_gather.item_name != item_name:
		return
	current_count += 1
	
	QuestManager.update_task_list_item.emit(task_id)
	
	if current_count >= number_to_get and !completed:
		QuestManager.play_task_completion_animation.emit(task_id)
		completed = true
	#save task
	
func decrement_count(item_name : String) -> void:
	if item_to_gather.item_name != item_name:
		return
		
	current_count = max(0, current_count-1)
	
	QuestManager.update_task_list_item.emit(task_id)
	
	if current_count < number_to_get and completed:
		QuestManager.play_undo_task_completion_animation.emit(task_id)
		completed = false

	#save task
	

func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Gather %s: %s/%s" % [item_to_gather.item_name, current_count, number_to_get]
	new_task.icon.texture = item_to_gather.shop_icon
	new_task.task_data = self
	return new_task
