class_name CheckPointButton extends Button

@export var index = 0
@onready var arrow: TextureRect = $Arrow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.check_point_button_clicked.connect(check_if_spawn_location)
	if GameManager.spawn_location == index:
		arrow.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	SignalBus.update_entrance_map.emit(index)
	SignalBus.update_mode_description_to_expedition.emit()
	SignalBus.set_mode_to_expedition.emit()
	GameManager.hunt_challenge_selected = false
	arrow.show()
	SignalBus.check_point_button_clicked.emit(index)

func check_if_spawn_location(chosen_index : int) -> void:
	if index != chosen_index:
		arrow.hide()
