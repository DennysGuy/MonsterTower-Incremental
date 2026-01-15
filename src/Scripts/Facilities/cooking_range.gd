class_name CookingRangeGraphic extends Sprite2D

const COOKING_RANGE = preload("uid://bry4670ns2btd")
const COOKING_RANGE_CONTSTRUCTION = preload("uid://53gha3pmge8a")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.unlock_cooking_station.connect(unlock_station)
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		texture = COOKING_RANGE
	else:
		texture = COOKING_RANGE_CONTSTRUCTION



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func unlock_station() -> void:
	texture = COOKING_RANGE
