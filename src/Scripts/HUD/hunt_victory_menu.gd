class_name HuntVictoryMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const NEW_VICTORY_THEME = preload("uid://bdv4pum2wfbbp")

@onready var floor_reached: Label = $ResultsPanel/GoalPanel/FloorReached

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animation_player.play("CloseOut")
	floor_reached.text = "Hunt Challenge - %s %s" %[GameManager.previous_map_data.biome, GameManager.previous_map_data.floor_name]
	MusicPlayer.play_song(NEW_VICTORY_THEME,4.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_starshire() -> void:
	MusicPlayer.stop_player()
	GameManager.spawn_location = 0
	GameManager.resupply_character = true
	get_tree().change_scene_to_file("uid://cq0un0c22235d")
	
func _on_to_town_button_up() -> void:
	animation_player.play("CloseIn_Town")
