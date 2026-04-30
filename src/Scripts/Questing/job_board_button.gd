class_name JobBoardButton extends MarginContainer

@export var quest_data : Quest
@export var job_board_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_job_board_button_button_up() -> void:
	QuestManager.populate_job_board_description_box.emit(quest_data)
