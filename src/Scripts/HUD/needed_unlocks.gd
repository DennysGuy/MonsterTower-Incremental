class_name NeededUnlocksPanel extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerStats.check_needed_for_dojo():
		hide()
	else:
		show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
