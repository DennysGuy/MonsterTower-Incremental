class_name GhostPlayer extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
var radius := 10.0
var speed := 1.0
var center := Vector2.ZERO
var angle := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate:a",1.0,2)
	
	angle += speed * delta
	global_position.x = get_parent().global_position.x + radius * cos(angle)
	global_position.y = get_parent().global_position.y + radius * sin(angle)
