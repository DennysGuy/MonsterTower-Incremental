class_name HuntFailureMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floor_reached: Label = $ResultsPanel/GoalPanel/FloorReached
@onready var to_town: Button = $ResultsPanel/ToTown
@onready var new_run: Button = $ResultsPanel/NewRun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("CloseOut")
	floor_reached.text = "Hunt Challenge - %s %s" %[GameManager.previous_map_data.biome, GameManager.previous_map_data.floor_name]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_starshire() -> void:
	MusicPlayer.stop_player()
	GameManager.spawn_location = 0
	GameManager.resupply_character = true
	get_tree().change_scene_to_file("uid://cq0un0c22235d")

func go_to_tower() -> void:
	#Need to store the previous map we went to - or give them a way to select location
	GameManager.hunt_challenge_selected = true
	GameManager.resupply_character = true
	get_tree().change_scene_to_file(GameManager.previous_map_path)

func _on_to_town_button_up() -> void:
	animation_player.play("CloseIn_Town")


func _on_new_run_button_up() -> void:
	animation_player.play("CloseIn_Tower")
