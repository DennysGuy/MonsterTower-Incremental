class_name BossHPBar extends Control


const GREY_SENTINEL_HP_BAR_BASE = preload("uid://dv47hkd6ub8et")
const GREY_SENTINEL_HP_BAR_FILL = preload("uid://0s65nik5y3w5")

@onready var hp_bar: TextureProgressBar = $HPBar
@onready var boss_name_label: Label = $BossNameLabel
@onready var boss_hp_label: Label = $BossHPLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#We will come back and redo this when we want to swap out textures
	PlayerHudSignalBus.update_boss_hp_bar.connect(update_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_hp(max_value : int, current_value : int) -> void:
	hp_bar.max_value = max_value
	hp_bar.value = current_value
	boss_hp_label.text = "(%s/%s)" % [current_value,max_value]
