class_name GemStoneStation extends Control

@onready var gem_stone_container: GridContainer = $GemStoneContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_gem_bag_container()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func update_gem_bag_container() -> void:
	InventoryManager.update_grid_container(gem_stone_container, "Gem Stones", false)


func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()


func _on_close_button_button_up() -> void:
	close_out()
