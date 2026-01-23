class_name SmithingStation extends Sprite2D


@onready var notification_icon: NotificationIcon = $NotificationIcon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.check_can_sword_craft.connect(notify_can_craft)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func notify_can_craft() -> void:
	if PlayerStats.can_craft_next_sword():
		notification_icon.set_new_notice_icon()
	else:
		notification_icon.hide_icon()
