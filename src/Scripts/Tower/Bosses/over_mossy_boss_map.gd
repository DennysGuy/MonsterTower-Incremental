class_name OverMossyBossMap extends MapOver


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu") and GameManager.can_pause_game:
		spawn_pause_menu()
