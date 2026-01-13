class_name TechTreeComputer extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var press_e: Label = $PressE

var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.player_can_move and player_in_range and Input.is_action_just_pressed("interact"):
		SignalBus.spawn_tech_tree.emit()

func _on_facility_interactable_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		press_e.show()

func _on_facility_interactable_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		press_e.hide()
