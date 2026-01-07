class_name PracticeDummy extends Enemy

@onready var timer: Timer = $Timer

func _ready() -> void:
	super()
	print(player)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func _physics_process(delta: float) -> void:
	super(delta)
	
func _process(delta: float) -> void:
	super(delta)

func _on_health_component_update_health_bar() -> void:
	update_health_bar()
