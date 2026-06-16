class_name HitStarsVFX extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var possible_scales : Array[Vector2] = [Vector2(0.7,0.7), Vector2(0.8,0.8),Vector2.ONE, Vector2(1.2,1.2), Vector2(1.5,1.5), Vector2(1.4,1.4), Vector2(1.6,1.6), Vector2(1.8,1.8)]

var possible_angles : Array[float] = [0.0, 30.0, 60.0, -30.0, 45.0, -60.0, -45.0, 20.0, 15.0, -25.0 -15.0]

@onready var hit_stars_graphic: Sprite2D = $HitStarsGraphic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_stars_graphic.rotation = possible_angles.pick_random()
	hit_stars_graphic.scale = possible_scales.pick_random()
	animation_player.play("Burst")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
