class_name ClassSigil extends Control


@export var icon_texture : Texture2D
@export var title_name : String
@export_multiline var class_description : String

@export var icon: TextureRect
@export var title: Label 
@export var description: RichTextLabel
@onready var class_description_box: Panel = $ClassDescriptionBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if icon_texture:
		icon.texture = icon_texture
	title.text = title_name
	description.text = class_description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_icon_mouse_entered() -> void:
	class_description_box.show()


func _on_icon_mouse_exited() -> void:
	class_description_box.hide()
