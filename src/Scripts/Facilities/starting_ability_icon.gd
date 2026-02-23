class_name StartingAbilityIcon extends TextureRect

@export var ability : Ability
@export var icon : Texture2D

@onready var starting_ability_description_panel: ColorRect = $StartingAbilityDescriptionPanel

@onready var ability_name: Label = $StartingAbilityDescriptionPanel/AbilityName
@onready var description: RichTextLabel = $StartingAbilityDescriptionPanel/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = icon
	ability_name.text = ability.ability_name
	description.text = ability.ability_description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_info_card() -> void:
	pass

func _on_mouse_entered() -> void:
	starting_ability_description_panel.show()

func _on_mouse_exited() -> void:
	starting_ability_description_panel.hide()
