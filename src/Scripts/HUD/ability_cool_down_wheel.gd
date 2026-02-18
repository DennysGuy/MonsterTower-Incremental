class_name AbilityCooldownWheel extends Control

@export var ability_name : String
@onready var progress_wheel: TextureProgressBar = $ProgressWheel
@onready var icon: TextureRect = $Icon

var timer_started : bool = false
@onready var spark_emit_point: Marker2D = $SparkEmitPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AbilityTimers.start_ability_cooldown_timer.connect(start_progress_wheel)
	TechTreeManager.set_ability_hud_icon.connect(set_icon)
	set_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if timer_started:
		progress_wheel.value = AbilityTimers.ability_state[ability_name]["Timer"].time_left
		if progress_wheel.value <= 0:
			emit_ready_spark()
			timer_started = false

func start_progress_wheel(selected_ability : String) -> void:
	if selected_ability != ability_name:
		return
	
	progress_wheel.max_value = AbilityTimers.ability_state[selected_ability]["Timer"].wait_time
	progress_wheel.value = progress_wheel.max_value
	timer_started = true
	

func emit_ready_spark() -> void:
	var ready_spark := preload("uid://caecanj86lyrx").instantiate()
	ready_spark.position = spark_emit_point.position
	add_child(ready_spark)

func set_icon() -> void:
	match ability_name:
		"Air Attack":
			if PlayerStats.facilities_unlocked["Arial Slash"]:
				icon.texture = preload("uid://q06lybw2gchf")
			else:
				icon.texture = preload("uid://cbcw7ua8sro78")
		"Double Jump":
			if PlayerStats.facilities_unlocked["Double Jump"]:
				icon.texture = preload("uid://dduqgitj2ii5a")
			else:
				icon.texture = preload("uid://cbcw7ua8sro78")
		"Dash Attack":
			if PlayerStats.facilities_unlocked["Dash Attack"]:
				icon.texture = preload("uid://dx6yh1h66vork")
			else:
				icon.texture = preload("uid://cbcw7ua8sro78")
		"Special Attack":
			if PlayerStats.equipped_abilities["Special Attack"]:
				icon.texture = preload("uid://dx6yh1h66vork")
			else:
				icon.texture = preload("uid://cbcw7ua8sro78")
