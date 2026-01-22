class_name Biome1Floor2 extends Map

var player_in_exit_area : bool = false
@onready var guide_log: Label = $GuideLog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	SignalBus.spawn_enemies.emit()
	
	if ore_rock_markers:
		spawn_ore_rocks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_exit_area and player.damageable:
		go_to_starshire()

func _on_tower_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_exit_area = true
		guide_log.show()


func _on_tower_exit_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_exit_area = true
		guide_log.hide()
