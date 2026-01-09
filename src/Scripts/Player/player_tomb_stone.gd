class_name PlayerTombStone extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("TombStoneDrop")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func screen_shake() -> void:
	SignalBus.shake_camera.emit(4)

func remove_tomb_stone() -> void:
	queue_free()

func spawn_player_ghost_body() -> void:
	var ghost : GhostPlayer = preload("uid://dfuh68cf5rs3").instantiate()
	ghost.position.y -= 50
	add_child(ghost)
