class_name CodexNotificationPanel extends Panel

@onready var message: RichTextLabel = $Message


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CodexManager.send_codex_notification.connect(set_message)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_message(codex_message: String) -> void:
	message.text = codex_message
	CodexManager.show_codex_notification.emit()
