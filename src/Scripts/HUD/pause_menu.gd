class_name PauseMenu extends Control

@onready var sfx_slider: HSlider = $Panel/BG/AudioControlPanel/SfxSlider
@onready var music_slider: HSlider = $Panel/BG/AudioControlPanel/MusicSlider
@onready var ambience_slider: HSlider = $Panel/BG/AudioControlPanel/AmbienceSlider
var in_menu : bool = false
func _ready() -> void:
	get_tree().paused = true
	in_menu = true
	

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_button_button_up() -> void:
	get_tree().paused = false
	queue_free()


func set_pause_subtree(root: Node, pause: bool) -> void:
	var process_setters = [
	"set_physics_process"]
	
	for setter in process_setters:
		root.propagate_call(setter, [!pause])
