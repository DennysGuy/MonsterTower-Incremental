class_name RespawnBox extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_2: Button = $RespawnBG/Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.hunt_challenge_selected:
		button_2.show()
	animation_player.play("SpawnIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	GameManager.resupply_character = true
	SignalBus.return_to_starshire.emit()


func _on_button_2_button_up() -> void:
	GameManager.hunt_challenge_selected = true
	GameManager.resupply_character = true
	get_tree().change_scene_to_file(GameManager.previous_map_path)
