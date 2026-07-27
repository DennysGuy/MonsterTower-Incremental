class_name UpgradeTrackerButton extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_pulse() -> void:
	animation_player.play("pulse")

func stop_pulse() -> void:
	animation_player.stop()
	scale = Vector2(1.0,1.0)
