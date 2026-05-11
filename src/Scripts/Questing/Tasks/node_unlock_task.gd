class_name NodeUnlockTask extends Task

@export var node_name : String


func check_node_name(selected_node_name : String) -> void:
	if selected_node_name != node_name or completed:
		return 
	
	complete_task()

func check_if_already_purchased() -> void:
	var selected_node_status : bool = SaveManager.current_save_game.tech_nodes[node_name]["Unlocked"]
	
	if selected_node_status:
		complete_task()
	
func connect_signals() -> void:
	if !QuestManager.check_node_name.connect(check_node_name):
		QuestManager.check_node_name.connect(check_node_name)

func build_task_list_item() -> TaskListItem:
	#we'll load in the necessary data here
	var new_task : TaskListItem = preload("uid://cb5m6ynmba10o").instantiate()
	new_task.label.text = "Unlock %s Node" % node_name
	new_task.task_data = self
	return new_task
