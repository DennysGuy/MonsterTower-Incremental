class_name TechTree extends Node2D

@onready var currency: Label = $CanvasLayer/Currency
@onready var presitge_tier: Label = $CanvasLayer/PresitgeTier
@onready var prestige_progress: Label = $CanvasLayer/PrestigeProgress
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.update_currency_label.connect(update_currency_label)
	TechTreeManager.update_prestige_tier_label.connect(update_prestige_label)
	TechTreeManager.update_prestige_tier_progress_label.connect(update_prestige_progress)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("add_currency"):
		TechTreeManager.currency += 25
		update_currency_label()

func update_currency_label() -> void:
	currency.text = "Currency: %s" % [TechTreeManager.currency]

func update_prestige_label() -> void:
	presitge_tier.text = "Prestige: %s" % [TechTreeManager.current_prestige]

func update_prestige_progress() -> void:
	prestige_progress.text = "%s/%s" % [TechTreeManager.current_upgrade_count, TechTreeManager.upgrade_count_to_prestige]
	progress_bar.max_value = TechTreeManager.upgrade_count_to_prestige
	progress_bar.value = TechTreeManager.current_upgrade_count
