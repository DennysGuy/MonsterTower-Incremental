class_name CookingRangeGraphic extends Sprite2D

const COOKING_RANGE = preload("uid://bry4670ns2btd")
const COOKING_RANGE_CONTSTRUCTION = preload("uid://53gha3pmge8a")
@onready var notification_icon: NotificationIcon = $NotificationIcon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SignalBus.unlock_cooking_station.connect(unlock_station)
	CookingManager.can_craft_dish.connect(check_if_can_cook)
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		texture = COOKING_RANGE
	else:
		texture = COOKING_RANGE_CONTSTRUCTION
		
	check_if_can_cook()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func unlock_station() -> void:
	texture = COOKING_RANGE
	
func check_if_can_cook() -> void:
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		if CookingManager.can_cook_recipe():
			notification_icon.set_notice_icon()
			SignalBus.show_can_cook_dish_label.emit()
		else:
			notification_icon.hide()
			SignalBus.hide_can_cook_dish_label.emit()
