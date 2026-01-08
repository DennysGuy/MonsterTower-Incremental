class_name LadderArea extends Area2D

@export var ladder_top : Marker2D
@export var ladder_bottom : Marker2D

var ladder_top_position : float
var ladder_bottom_position : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ladder_top_position = ladder_top.global_position.y
	ladder_bottom_position = ladder_bottom.global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
