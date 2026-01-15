class_name SmeltingStationGraphic extends Sprite2D


const SMELTING_STATION_CONTRUCTION_MODE = preload("uid://chhm5f5xmlr0j")
const SMELTING_STATION = preload("uid://btbqj1pb1hac")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.unlock_refinery.connect(unlock_station)
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		texture = SMELTING_STATION
	else:
		texture = SMELTING_STATION_CONTRUCTION_MODE

func unlock_station() -> void:
	texture = SMELTING_STATION
