class_name ActiveAbilityButton extends TextureButton

@export var ability : ClassAbilityNodeStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_normal = ability.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	AbilitiesMenuManager.active_ability_button_pressed.emit(ability)


func _on_mouse_entered() -> void:
	pass # Replace with function body.
