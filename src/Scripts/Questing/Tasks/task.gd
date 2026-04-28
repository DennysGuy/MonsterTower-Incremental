class_name Task extends Resource

@export var task_id : int
@export var completed : bool = false

enum TYPE {GATHERING, HUNTING, LEVELING, FACILITY_UNLOCK, MAP_UNLOCK, NODE_UNLOCK}
@export var task_type : TYPE = TYPE.GATHERING

func build_task_list_item() -> TaskListItem:
	'''
	- We will override this function in other child tasks to build a unique task
	'''
	return null
