class_name CardKeyLock extends Node2D

@onready var card_key_lock: Sprite2D = $CardKeyLock

const CARD_KEY_LOCK_FILLED = preload("uid://b66xfcxpp48yg")
const CARD_KEY_LOCK_UNFILLED = preload("uid://dovhk1103xlqf")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_card_key_lock_filled() -> void:
	card_key_lock.texture = CARD_KEY_LOCK_FILLED

func set_card_key_lock_unfilled() -> void:
	card_key_lock.texture = CARD_KEY_LOCK_FILLED
