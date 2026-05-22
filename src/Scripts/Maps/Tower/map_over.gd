class_name MapOver extends Node

@export var hud : PlayerHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu") and GameManager.can_pause_game:
		spawn_pause_menu()

func spawn_pause_menu() -> void:
	var pause_menu : PauseMenu = preload("uid://dlaq2oh2iuyjk").instantiate()
	hud.add_child(pause_menu)
