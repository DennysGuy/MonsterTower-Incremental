class_name SmeltingStationGraphic extends Sprite2D


const SMELTING_STATION_CONTRUCTION_MODE = preload("uid://chhm5f5xmlr0j")
const SMELTING_STATION = preload("uid://btbqj1pb1hac")

@onready var notification_icon: NotificationIcon = $NotificationIcon
@onready var needed_unlocks: NeededUnlocksPanel = $NeededUnlocks


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.unlock_refinery.connect(unlock_station)
	CookingManager.can_craft_bar.connect(check_if_can_smelt)
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		texture = SMELTING_STATION
		needed_unlocks.hide()
	else:
		texture = SMELTING_STATION_CONTRUCTION_MODE
		needed_unlocks.show()

func unlock_station() -> void:
	texture = SMELTING_STATION

func check_if_can_smelt() -> void:
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		if CookingManager.can_refine_bar():
			notification_icon.set_notice_icon()
			SignalBus.show_can_smelt_bar_label.emit()
		else:
			notification_icon.hide()
			SignalBus.hide_can_smelt_bar_label.emit()
