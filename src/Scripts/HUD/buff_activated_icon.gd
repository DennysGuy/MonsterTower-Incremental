class_name BuffActivatedIcon extends Control

@export var icon : TextureRect
@export var progress_bar : ProgressBar
@export var timer_ref : Timer

var stored_ability : Ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	progress_bar.value = timer_ref.time_left
	
	if progress_bar.value <= 0:
		queue_free()

func initialize(timer : Timer, ability : Ability) -> void:
	stored_ability = ability
	timer_ref = timer
	icon.texture = ability.icon
	progress_bar.max_value = timer.wait_time
	progress_bar.value = timer.wait_time
