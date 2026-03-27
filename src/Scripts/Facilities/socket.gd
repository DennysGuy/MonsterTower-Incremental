class_name Socket extends Control

@onready var icon: TextureRect = $Icon
@export var gem_stone : GemStone

func _ready() -> void:
	if gem_stone:
		icon.texture = gem_stone.socket_graphic
