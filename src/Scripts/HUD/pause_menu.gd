class_name PauseMenu extends Control

@onready var sfx_slider: HSlider = $Panel/BG/AudioControlPanel/SfxSlider
@onready var music_slider: HSlider = $Panel/BG/AudioControlPanel/MusicSlider
@onready var ambience_slider: HSlider = $Panel/BG/AudioControlPanel/AmbienceSlider

var in_menu : bool = false

@export var audio_settings_menu : AudioSettingsMenu
@export var control_settings_menu : ControlSettingsMenu
@export var graphics_settings_menu : GraphicsSettingsMenu
@export var pause_game : bool = true

func _ready() -> void:
	if pause_game:
		get_tree().paused = true
		in_menu = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		exit_pause_menu()

func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func exit_pause_menu() -> void:
	get_tree().paused = false
	SignalBus.hide_tech_tree_canvas_layer.emit()
	PlayerHudSignalBus.hub_menu_exited.emit()
	queue_free()

func set_pause_subtree(root: Node, pause: bool) -> void:
	var process_setters = [
	"set_physics_process"]
	
	for setter in process_setters:
		root.propagate_call(setter, [!pause])

func _on_audio_settings_button_up() -> void:
	audio_settings_menu.show()

func _on_graphics_settings_button_up() -> void:
	graphics_settings_menu.show()

func _on_control_settings_button_up() -> void:
	control_settings_menu.show()

func _on_save_and_menu_button_up() -> void:
	SaveManager.save_game()
	MusicPlayer.stop_player()
	get_tree().change_scene_to_file("uid://babypuakc7i7y")

func _on_quit_game_button_up() -> void:
	get_tree().quit()

func _on_exit_button_button_up() -> void:
	exit_pause_menu()
