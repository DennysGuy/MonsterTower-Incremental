class_name Map extends Node2D

@export var map_name : String
@export var map_id : int
@export var spawn_point : Marker2D
@export var player_spawn : bool = true
@export var camera : PlayerCamera
@export var hud : PlayerHUD
@export var ore_rock_spawn_rate : float
@export var ore_rock_markers : Node

@export var next_room_path : String

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.move_to_next_room.connect(move_to_next_room)
	hud.map_name_label.text = map_name
	if player_spawn:
		spawn_player()
	
		if camera:
			camera.player = player
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player() -> void:
	var new_player : Player = preload("uid://wuy3aelq8aeg").instantiate()
	player = new_player
	player.position = spawn_point.position
	add_child(player)
	print(player)


func go_to_starshire() -> void:
	hud.animation_player.play("CloseOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/UI/ExpeditionResultsScreen.tscn")


func move_to_next_room() -> void:
	if next_room_path:
		hud.animation_player.play("CloseOut")
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(next_room_path)


func roll_ore_spawn_chance() -> int:
	var rand_check : int = randi_range(0,100)
	return rand_check <= int(100 * ore_rock_spawn_rate)


func spawn_ore_rocks() -> void:
	for ore_rock_marker in ore_rock_markers.get_children():
			if roll_ore_spawn_chance():
				ore_rock_marker.spawn_ore_rock()
