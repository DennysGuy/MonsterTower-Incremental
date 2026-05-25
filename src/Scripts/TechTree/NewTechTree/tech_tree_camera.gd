class_name TreeCamera extends Camera2D

var dragging : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("BOOOOOO")
		dragging = event.is_pressed()
	
	if event is InputEventMouseMotion and dragging:
		global_position -= event.relative / zoom
