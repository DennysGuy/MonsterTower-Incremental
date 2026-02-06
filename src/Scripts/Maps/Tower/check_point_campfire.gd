class_name CampFireCheckPoint extends Node2D

@export var reference_name : String
@export var entrance_data : TowerEntranceData
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_notification: Label = $ExitNotification

@export var unlocked : bool = false
var just_unlocked : bool = false

@export var campfire: Sprite2D

var player_in_range : bool = false

func _ready() -> void:	
	if unlocked:
		animation_player.play("On")
	else:
		animation_player.play("Off")
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		SignalBus.return_to_starshire.emit()

#will need to have the player come across checkpoints in order
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not unlocked and not just_unlocked:
		entrance_data.number_of_spawn_locations += 1
		entrance_data.camp_fires_reached += 1
		animation_player.play("On")
		HitStopManager.freeze()
		save_floor_data()
		just_unlocked = true
		

func save_floor_data() -> void:
	var saved_data = SaveManager.current_save_game.tower_entrance_data
	saved_data[entrance_data.floor_name]["Number of Spawn Locations"] = entrance_data.number_of_spawn_locations
	saved_data[entrance_data.floor_name]["Campfires Reached"] = entrance_data.camp_fires_reached
	SaveManager.save_game()
		


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		exit_notification.show()
		player_in_range = true


func _on_exit_area_body_exited(body: Node2D) -> void:
	if body is Player:
		exit_notification.hide()
		player_in_range = false
