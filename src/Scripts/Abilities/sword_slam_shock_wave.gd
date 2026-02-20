class_name SwordSlamShockWave extends Node2D


@export var move_speed : float
@export var flip_dir : bool = false
@export var move_dir : int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.flip_h = flip_dir
	animated_sprite_2d.play("default")
	
func _physics_process(delta: float) -> void:
	position.x += move_speed * move_dir


func _on_timer_timeout() -> void:
	queue_free()


func _on_hit_box_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func flip_direction() -> void:
	flip_dir = true
	move_dir = -1
