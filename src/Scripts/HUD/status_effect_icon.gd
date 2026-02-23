class_name StatusEffectIcon extends TextureRect

enum STATUS_TYPE {SLOW, SILENCED}
var status_type : STATUS_TYPE

const SLOW_STATUS_ICON = preload("uid://b5vu1c0qxs2n7")
const SILENCED_STATUS_ICON = preload("uid://b7mak2j8wyvbh")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_icon() -> void:
	match status_type:
		STATUS_TYPE.SLOW:
			texture = SLOW_STATUS_ICON
		STATUS_TYPE.SILENCED:
			texture = SILENCED_STATUS_ICON

func set_as_slow_status() -> void:
	status_type = STATUS_TYPE.SLOW

func set_as_silenced_status() -> void:
	status_type = STATUS_TYPE.SILENCED

func is_slow_status_icon() -> bool:
	return status_type == STATUS_TYPE.SLOW

func is_silenced_status_icon() -> bool:
	return status_type == STATUS_TYPE.SILENCED
