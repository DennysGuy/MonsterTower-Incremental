class_name NameTag extends Control


const ELITE_ENEMY_NAME_TAG_GRAPHIC = preload("uid://dg4dmliimpjga")
const GENERIC_NAME_TAG_GRAPHIC = preload("uid://d2pxutob3xbxq")

@onready var bg: PanelContainer = $Bg

@onready var tag: Label = $Bg/Tag

@export var is_elite_enemy : bool 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
