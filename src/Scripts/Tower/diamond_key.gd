class_name DiamondKey extends Node2D

var player : Player
var base_y : float
var t : float = 0.0
@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0

@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = sprite_2d.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if player:
		global_position = global_position.move_toward(player.holder.global_position,2.8)

	t += delta * hover_speed
	sprite_2d.position.y = base_y + sin(t) * hover_height

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
