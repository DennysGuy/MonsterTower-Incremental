class_name PracticeDummy extends Enemy

@onready var timer: Timer = $Timer
@onready var directions: Label = $Directions

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

func _on_directions_area_body_entered(body: Node2D) -> void:
	if body is Player:
		directions.show()

func _on_directions_area_body_exited(body: Node2D) -> void:
	if body is Player:
		directions.hide()
