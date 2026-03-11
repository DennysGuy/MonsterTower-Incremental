class_name AbilityRowLock extends Panel

@export var required_level : int = 0
@onready var required_level_label: Label = $RequiredLevelLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	required_level_label.text = "Level %s" % required_level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
