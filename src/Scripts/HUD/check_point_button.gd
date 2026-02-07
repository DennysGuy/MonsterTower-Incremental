class_name CheckPointButton extends Button

@export var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	SignalBus.update_entrance_map.emit(index)
	SignalBus.update_mode_description_to_expedition.emit()
	SignalBus.set_mode_to_expedition.emit()
	GameManager.hunt_challenge_selected = false
