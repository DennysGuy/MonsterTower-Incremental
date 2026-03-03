class_name CraftingItemSpawn extends Node2D

@export var icon: Sprite2D

@export var starting_ending_area : Area2D
@export var ending_area : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = starting_ending_area.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position = position.move_toward(ending_area.global_position, 10)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == ending_area:
		queue_free()
