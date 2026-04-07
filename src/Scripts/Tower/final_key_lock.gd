class_name FinalKeyLock extends Node2D

@onready var final_key_lock: Sprite2D = $FinalKeyLock

const FINAL_KEY_LOCK_FILLED = preload("uid://c0uj4ytmi8aeb")
const FINAL_KEY_LOCK_UNFILLED = preload("uid://d2ffo7hixe8t0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_final_key_lock_unfilled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_final_key_lock_filled() -> void:
	final_key_lock.texture = FINAL_KEY_LOCK_FILLED

func set_final_key_lock_unfilled() -> void:
	final_key_lock.texture = FINAL_KEY_LOCK_UNFILLED
