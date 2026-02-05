class_name DojoUnlockItem extends Panel

@onready var texture_rect: TextureRect = $TextureRect
@export var name_of_needed : String
@onready var label: Label = $Label

enum UNLOCK_TYPE {STAT, FACILITY}
@export var unlock_type : UNLOCK_TYPE

@onready var check_box: TextureRect = $CheckBox
@onready var needed_exclamation: TextureRect = $NeededExclamation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var unlocked : bool = false
	label.text = name_of_needed
	match unlock_type:
		UNLOCK_TYPE.STAT:
			unlocked = PlayerStats.check_level_for_dojo()
		UNLOCK_TYPE.FACILITY:
			unlocked = PlayerStats.facilities_unlocked[name_of_needed]
	
	if unlocked:
		check_box.show()
		needed_exclamation.hide()
	else:
		check_box.hide()
		needed_exclamation.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
