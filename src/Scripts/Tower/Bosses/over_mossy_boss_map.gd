class_name OverMossyBossMap extends Node

@onready var hud: PlayerHUD = $HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.quest_hub.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
