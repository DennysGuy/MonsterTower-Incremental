class_name GraphicsSettingsMenu extends Panel

@onready var resolution_option_menu: OptionButton = $ResolutionOptionMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SettingsManager.is_windowed_mode():
		resolution_option_menu.disabled = false
	else:
		resolution_option_menu.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED)
			resolution_option_menu.disabled = false
		1:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.BORDERLESS)
			resolution_option_menu.disabled = true
		2:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.FULLSCREEN)
			resolution_option_menu.disabled = true


func _on_button_button_up() -> void:
	hide()


func _on_resolution_option_menu_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED, Vector2i(640,360))
		1:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED, Vector2i(1280,720))
		2:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED, Vector2i(1920,1080))
		3:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED, Vector2i(2560,1440))
		4:
			SettingsManager.set_window_mode(SettingsManager.WINDOW_MODE.WINDOWED, Vector2i(3840,2160))
