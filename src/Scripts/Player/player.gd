class_name Player extends Entity


func _ready() -> void:
	print(state_machine)
	super()

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	super(event)
