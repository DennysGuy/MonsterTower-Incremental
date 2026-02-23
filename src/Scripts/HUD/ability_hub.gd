class_name AbilityHub extends Control

@onready var license_tier_level: Label = $LicenseTierLevel

var license_tier_text : Dictionary = {
	0: "0",
	1: "I",
	2: "II",
	3: "III",
	4: "IV",
	5: "V",
	6: "VI",
	7: "VII",
	8: "VIII",
	9: "IX",
	10: "X"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.update_prestige_tier_label.connect(update_license_tier_level)
	update_license_tier_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_license_tier_level() -> void:
	license_tier_level.text = license_tier_text[TechTreeManager.current_prestige]


	
