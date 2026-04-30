class_name JobBoardButton extends MarginContainer

@export var quest_data : Quest
@export var job_board_button: Button
@export var notification_icon : TextureRect

const FACILITIES_NOTIFY = preload("uid://d0y4mpjou53tw")
const READY_TO_TURN_IN_ICON = preload("uid://dj6c42fctp72c")
const IN_PROGRESS_ICON = preload("uid://bhmoy2qtk83dj")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHudSignalBus.update_job_board_button.connect(update_button)
	update_button(quest_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_button(sent_quest_data : Quest) -> void:
	if sent_quest_data != quest_data:
		return
	
	if quest_data.is_ready_for_turn_in():
		notification_icon.texture = READY_TO_TURN_IN_ICON
	elif quest_data.is_in_progress():
		notification_icon.texture = IN_PROGRESS_ICON
	elif quest_data.is_available():
		notification_icon.texture = FACILITIES_NOTIFY

	notification_icon.show()
	
func _on_job_board_button_button_up() -> void:
	QuestManager.populate_job_board_description_box.emit(quest_data)
