extends Sprite2D

@export var hover_height : float = 4.0
@export var hover_speed : float = 2.0
var base_y : float
var t : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * hover_speed
	position.y = (base_y-60) + sin(t) * hover_height
