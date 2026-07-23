class_name Weapon3DPreview extends Node3D

@export var mesh : MeshInstance3D
@export var index : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func remove_disabled_material() -> void:
	mesh.material_overlay = null
