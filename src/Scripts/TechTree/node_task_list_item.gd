class_name NodeTaskListItem extends RichTextLabel

const TASK_COMPLETED = preload("uid://u4g1ea4v5nkg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_text(focused_task : NodeUnlockTask, completed : bool) -> void:
	text = "-Purchase %s Node" % focused_task.node_name
	if completed:
		GameManager.play_sfx(TASK_COMPLETED)
		text = "[color=green]-Purchase %s Node[/color]" % focused_task.node_name
	
