class_name GreySentinelBoss extends Boss

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot_shock_waves_left() -> void:
	SignalBus.shake_camera.emit(15)

func shoot_shock_waves_right() -> void:
	SignalBus.shake_camera.emit(15)
