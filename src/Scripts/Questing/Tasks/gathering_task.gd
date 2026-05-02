class_name GatheringTask extends Task

@export var item_to_gather : Item
@export var number_to_get : int
@export var current_count : int

#need to load data upon game start up
func increment_count(item : Item) -> void:
	if item_to_gather.item_name != item.item_name:
		return
	
	current_count = InventoryManager.get_quantity(item, item.get_inventory_name())
	
	QuestManager.update_task_list_item.emit(task_id)
	
	if current_count >= number_to_get and !completed:
		QuestManager.play_task_completion_animation.emit(task_id,true)
		completed = true
		SaveManager.save_task_completed_status(task_id, completed)
	#save task
	
func decrement_count(item : Item) -> void:
	if item_to_gather.item_name != item.item_name:
		return
		
	current_count = InventoryManager.get_quantity(item, item.get_inventory_name())
	
	QuestManager.update_task_list_item.emit(task_id)
	
	if current_count < number_to_get and completed:
		QuestManager.play_undo_task_completion_animation.emit(task_id)
		completed = false
		SaveManager.save_task_completed_status(task_id, completed)

	#save task

func reset_task_state() -> void:
	SaveManager.current_save_game.tasks[task_id]["Completed"] = false
	SaveManager.save_game()
	
func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Gather %s: %s/%s" % [item_to_gather.item_name, current_count, number_to_get]
	new_task.icon.texture = item_to_gather.shop_icon
	new_task.task_data = self
	return new_task

func remove_item_from_inventory() -> void:
	for i in range(number_to_get):
		InventoryManager.remove_item(item_to_gather.get_inventory_name(), item_to_gather)
