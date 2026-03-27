extends Marker2D

@export var gem_chest_stats : GemChestStats
@export var gem_chest : PackedScene
@export var spawn_parent : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_gem_chest() -> void:
	var spawned_gem_chest= gem_chest.instantiate() as GemStoneChest
	spawned_gem_chest.chest_stats = gem_chest_stats
	spawned_gem_chest.global_position = global_position
	spawn_parent.add_child(spawned_gem_chest)
