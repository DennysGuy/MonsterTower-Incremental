class_name TutorialBox extends NinePatchRect


@export var showing : bool = false
@export var task_id : int
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestManager.destroy_guide_box.connect(turn_off)
	var current_active_quest : String = QuestManager.active_quests["Main"][0]
	var active_quest : Quest = QuestManager.get_quest(current_active_quest)
	for task in active_quest.tasks:
		if task_id == task.task_id and !task.completed:
			showing = true
			break
	
	if showing:
		timer.start()
	else:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func turn_off(selected_id : int) -> void:
	if self.task_id == selected_id:
		queue_free()


func _on_timer_timeout() -> void:
	showing = !showing
	
	if showing:
		hide()
	else:
		show()
