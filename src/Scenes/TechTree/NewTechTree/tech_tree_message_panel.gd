class_name TechTreeMessagePanel extends Panel

@onready var class_tier: Label = $ClassTier
@onready var expedition_time: Label = $ExpeditionTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	class_tier.text = "Tier: %s" % TechTreeManager.current_prestige
	expedition_time.text = "Expedition Time: %s" % int(PlayerStats.player_stats["Expedition Time"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ok_button_button_up() -> void:
	SignalBus.close_message_panel.emit()
