class_name TowerEntranceButton extends TextureButton

@export var tower_entrance_data : TowerEntranceData
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("LockOnBlink")
	if PlayerStats.check_points_unlocked[tower_entrance_data.floor_name]:
		show()
	else:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	SignalBus.store_entrance_data.emit(tower_entrance_data)
