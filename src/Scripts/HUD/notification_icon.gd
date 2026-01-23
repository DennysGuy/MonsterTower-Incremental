class_name NotificationIcon extends TextureRect

const NOTICE_ICON = preload("uid://bggsgp4t53q5y")
const NEW_NOTICE_ICON = preload("uid://3n5w5v2q7e23")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_new_notice_icon() -> void:
	show()
	texture = NEW_NOTICE_ICON

func set_notice_icon() -> void:
	show()
	texture = NOTICE_ICON

func hide_icon() -> void:
	hide()
