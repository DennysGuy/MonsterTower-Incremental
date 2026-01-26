class_name Biome1Floor3 extends Map

var in_check_point_area : bool = false
@onready var checkpoint_log: Label = $CheckpointLog
@onready var checkpoint_campfire: AnimatedSprite2D = $CheckpointCampfire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	checkpoint_campfire.play("default")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and in_check_point_area:
		go_to_starshire()


func _on_checkpoint_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = true
		checkpoint_log.show()


func _on_checkpoint_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = false
		checkpoint_log.hide()
