class_name TutorialMap extends Map


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
