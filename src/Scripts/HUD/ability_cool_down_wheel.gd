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

@onready var lmb: TextureRect = $LMB
@onready var rmb: TextureRect = $RMB
@onready var shift: TextureRect = $SHIFT
@onready var space: TextureRect = $SPACE
@onready var button_1: TextureRect = $Button1
@onready var button_2: TextureRect = $Button2
@onready var button_3: TextureRect = $Button3
@onready var button_4: TextureRect = $Button4
@onready var count_down: Label = $CountDown



var stored_ability : Ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AbilityTimers.start_ability_cooldown_timer.connect(start_progress_wheel)
	TechTreeManager.set_ability_hud_icon.connect(set_icon)
	SignalBus.set_icons.connect(set_icon)
	SignalBus.unlock_cool_down_wheel.connect(unlock)
	SignalBus.set_combat_ability_icon_enabled.connect(set_combat_ability_enabled)
	SignalBus.set_combat_ability_icon_disabled.connect(set_combat_ability_disabled)
	PlayerHudSignalBus.check_if_can_cast_combat_ability.connect(check_if_can_cast)
	ability_title.text = ability_name
	stored_ability = PlayerStats.get_equipped_ability(ability_name)
	print(stored_ability)
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
		count_down.text = str(int(AbilityTimers.ability_state[ability_name]["Timer"].time_left))
		if progress_wheel.value <= 0:
			count_down.hide()
			emit_ready_spark()
			check_if_can_cast()
			timer_started = false

func start_progress_wheel(selected_ability : String) -> void:
	if selected_ability != ability_name:
		return
	
	count_down.show()
	progress_wheel.max_value = AbilityTimers.ability_state[selected_ability]["Timer"].wait_time
	progress_wheel.value = progress_wheel.max_value
	timer_started = true

func emit_ready_spark() -> void:
	var ready_spark := preload("uid://caecanj86lyrx").instantiate()
	ready_spark.position = spark_emit_point.position
	add_child(ready_spark)

func set_icon() -> void:
	if stored_ability:
		match stored_ability.ability_type:
			stored_ability.ABILITY_TYPE.AIR_ATTACK:
				if PlayerStats.facilities_unlocked["Arial Slash"]:
					icon.texture = stored_ability.icon
				lmb.show()
			stored_ability.ABILITY_TYPE.DASH:
				if PlayerStats.facilities_unlocked["Dash"]:
					icon.texture = stored_ability.icon
				rmb.show()
			stored_ability.ABILITY_TYPE.DOUBLE_JUMP:
				if PlayerStats.facilities_unlocked["Double Jump"]:
					icon.texture = stored_ability.icon				
				space.show()
			stored_ability.ABILITY_TYPE.COMBAT_ABILITY_1:
				icon.texture = stored_ability.icon
				button_1.show()
			stored_ability.ABILITY_TYPE.COMBAT_ABILITY_2:
				icon.texture = stored_ability.icon
				button_2.show()
			stored_ability.ABILITY_TYPE.COMBAT_ABILITY_3:
				icon.texture = stored_ability.icon
				button_3.show()
			stored_ability.ABILITY_TYPE.COMBAT_ABILITY_4:
				icon.texture = stored_ability.icon
				button_4.show()

func unlock(ability : Ability) -> void:
	if ability.get_ability_type_name() != ability_name:
		return
	
	stored_ability = ability
	set_icon()

func ability_unlocked() -> bool:
	return stored_ability != null

func _on_mouse_area_mouse_entered() -> void:
	if ability_unlocked():
		ability_description_panel.show()

func _on_texture_button_mouse_entered() -> void:
	if ability_unlocked():
		ability_description_panel.show()

func _on_texture_button_mouse_exited() -> void:
	if ability_unlocked():
		ability_description_panel.hide()

func check_if_can_cast() -> void:
	if !stored_ability:
		return
	
	if stored_ability and !stored_ability.is_combat_ability:
		return
	
	if PlayerStats.player_stats["Current MP"] < stored_ability.mp_cost:
		icon.texture = stored_ability.disabled_icon
	else:
		icon.texture = stored_ability.icon

func set_combat_ability_enabled() -> void:
	if !stored_ability:
		return
	if !stored_ability.is_combat_ability:
		return
	icon.texture = stored_ability.icon

func set_combat_ability_disabled() -> void:
	if !stored_ability:
		return
	
	if !stored_ability.is_combat_ability:
		return
	icon.texture = stored_ability.disabled_icon
