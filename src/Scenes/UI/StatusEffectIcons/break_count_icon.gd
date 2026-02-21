class_name BreakStatusIcon extends Control

@export var count_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_count_label(current_count : int, max_count : int) -> void:
	count_label.text = "%s/%s" % [current_count,max_count]
