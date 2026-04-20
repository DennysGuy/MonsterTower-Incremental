class_name GemStoneStationFacility extends Sprite2D

@onready var arrow_at_ore: Sprite2D = $ArrowAtOre

func _ready() -> void:
	SignalBus.show_gem_station_arrow.connect(show_arrow)
	if PlayerStats.facilities_unlocked["Gem Stone Station"]:
		show_arrow()

func show_arrow() -> void:
	arrow_at_ore.show()
