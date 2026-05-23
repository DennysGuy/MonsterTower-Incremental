class_name GraphicsSettingsMenu extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED)
		1:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.BORDERLESS)
		2:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.FULLSCREEN)


func _on_resolution_setting_option_menu_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_button_button_up() -> void:
	hide()
