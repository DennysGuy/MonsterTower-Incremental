class_name NewStarShireMap extends Map


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_tech_tree_to_scene() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/TechTree/TechTree.tscn")
