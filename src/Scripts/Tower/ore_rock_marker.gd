class_name OreRockMarker extends Marker2D

@export var ore_rock_resource : OreRockStats
@export var ore_rock : PackedScene
@export var chance_to_spawn : float

@export var spawn_parent : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func spawn_ore_rock() -> void:
	var spawned_ore_rock = ore_rock.instantiate() as OreRock
	spawned_ore_rock.ore_rock_stats = ore_rock_resource
	spawned_ore_rock.global_position = global_position
	spawn_parent.add_child(spawned_ore_rock)
