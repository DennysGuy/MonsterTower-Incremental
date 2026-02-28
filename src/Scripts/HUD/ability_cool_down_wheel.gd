class_name AbilityCooldownWheel extends Control

@export var ability_name : String
@onready var progress_wheel: TextureProgressBar = $ProgressWheel
@onready var icon: TextureRect = $Icon

var timer_started : bool = false
@onready var spark_emit_point: Marker2D = $SparkEmitPoint
@onready var ability_title: Label = $AbilityDescriptionPanel/AbilityTitle
@onready var description: RichTextLabel = $AbilityDescriptionPanel/Description
@onready var ability_description_panel: Panel = $AbilityDescriptionPanel

var ability_loaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AbilityTimers.start_ability_cooldown_timer.connect(start_progress_wheel)
	TechTreeManager.set_ability_hud_icon.connect(set_icon)
	SignalBus.set_icons.connect(set_icon)
	ability_title.text = ability_name
	#description.text = PlayerStats.get_equipped_ability(ability_name).ability_description
	set_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerStats.get_equipped_ability(ability_name) and !ability_loaded:
		description.text = PlayerStats.get_equipped_ability(ability_name).ability_description
		ability_loaded = true
		
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
				icon.texture = preload("uid://dnqar1vwb0eae")
			else:
				icon.texture = preload("uid://cbcw7ua8sro78")

func ability_unlocked() -> bool:
	if ability_name == "Special Attack":
		return PlayerStats.get_equipped_ability("Special Attack") != null
	
	match ability_name:
		"Air Attack": 
			return PlayerStats.facilities_unlocked["Arial Slash"]
		"Dash Attack":
			return PlayerStats.facilities_unlocked[ability_name]
		"Double Jump":
			return PlayerStats.facilities_unlocked[ability_name]

	return false

func _on_mouse_area_mouse_entered() -> void:
	if ability_unlocked():
		ability_description_panel.show()

func _on_texture_button_mouse_entered() -> void:
	if ability_unlocked():
		ability_description_panel.show()

func _on_texture_button_mouse_exited() -> void:
	if ability_unlocked():
		ability_description_panel.hide()
