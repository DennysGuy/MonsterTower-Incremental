class_name NewStarShireMap extends Map

@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_tech_tree_to_scene() -> void:
	var tech_tree : TechTree = preload("uid://b7n3fwd3y85wp").instantiate()
	sub_viewport.add_child(tech_tree)
