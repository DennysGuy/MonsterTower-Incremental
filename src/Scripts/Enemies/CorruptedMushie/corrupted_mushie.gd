class_name CorruptedMushie extends Enemy

@warning_ignore("unused_signal")
signal on_death
@onready var timer: Timer = $Timer

var can_chase : bool = false

func _ready() -> void:
	super()

func _on_health_component_update_health_bar() -> void:
	update_health_bar()
