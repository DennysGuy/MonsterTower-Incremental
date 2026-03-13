class_name AbilityTreeNodeRow extends Panel

@onready var focus_marker: Marker2D = $FocusArea

@onready var select_arrows: Control = $SelectArrows


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_arrows() -> void:
	select_arrows.show()

func hide_arrows() -> void:
	select_arrows.hide()
