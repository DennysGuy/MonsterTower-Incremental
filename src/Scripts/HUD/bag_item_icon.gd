class_name BagItemIcon extends TextureRect

var base_y : float
var t : float = 0.0
@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * hover_speed
	position.y = base_y + sin(t) * hover_height
