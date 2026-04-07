class_name DiamondKeyLock extends Node2D

@onready var diamond_key_lock_graphic: Sprite2D = $DiamondKeyLockGraphic

const DIAMOND_KEY_LOCK_FILLED = preload("uid://b6nnf8bb3uqu")
const DIAMOND_KEY_LOCK_UNFILLED = preload("uid://mnfm4rqv2enk")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#We'll have to check if the room has been unlocked to set the graphic
	set_lock_unfilled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_lock_filled() -> void:
	diamond_key_lock_graphic.texture = DIAMOND_KEY_LOCK_FILLED

func set_lock_unfilled() -> void:
	diamond_key_lock_graphic.texture = DIAMOND_KEY_LOCK_UNFILLED
