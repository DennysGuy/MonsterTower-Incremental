class_name ClassSelectionNode extends Node2D

@onready var level_needed_panel: Panel = $LevelNeededPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerStats.player_stats["Level"] < 8:
		level_needed_panel.show()
	else:
		level_needed_panel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_node_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_node_button_up() -> void:
	SignalBus.spawn_class_selection_menu.emit()
	get_parent().queue_free()
