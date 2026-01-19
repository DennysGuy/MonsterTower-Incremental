class_name Floor1 extends Map

# Called when the node enters the scene tree for the first time.
@onready var guide_log: Label = $GuideLog

var player_in_range : bool = false

func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		go_to_starshire()

func _on_tower_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		guide_log.show()

func _on_tower_exit_area_body_exited(body: Node2D) -> void:
		player_in_range = false
		guide_log.hide()
