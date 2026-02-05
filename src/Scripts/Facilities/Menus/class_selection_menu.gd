class_name ClassSelectionMenu extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_warrior_select_2_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()
