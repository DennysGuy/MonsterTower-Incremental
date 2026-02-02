class_name CampFireCheckPoint extends Node2D

@export var entrance_data : TowerEntranceData
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var unlocked : bool = false

@export var campfire: Sprite2D
var just_unlocked : bool = false
func _ready() -> void:
	if unlocked:
		animation_player.play("On")
	else:
		animation_player.play("Off")
func _process(delta: float) -> void:
	pass

#will need to have the player come across checkpoints in order
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not unlocked and not just_unlocked:
		entrance_data.number_of_spawn_locations += 1
		entrance_data.camp_fires_reached += 1
		animation_player.play("On")
		HitStopManager.freeze()
		just_unlocked = true
		
