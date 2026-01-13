class_name TestFloor extends Map

@onready var guide_log: Label = $GuideLog

var player_in_exit_area : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if hud:
		hud.animation_player.play("CloseIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_exit_area:
		#we'll just return for now
		go_to_starshire()


func _on_tower_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		guide_log.show()
		player_in_exit_area = true


func _on_tower_exit_area_body_exited(body: Node2D) -> void:
	if body is Player:
		guide_log.hide()
		player_in_exit_area = false

func go_to_starshire() -> void:
	hud.animation_player.play("CloseOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/UI/ExpeditionResultsScreen.tscn")
