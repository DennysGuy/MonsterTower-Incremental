extends Camera2D

const MOVE_SPEED : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_vector = Input.get_vector("pan_cam_left", "pan_cam_right", "pan_cam_up", "pan_cam_down")
	position += input_vector * MOVE_SPEED
