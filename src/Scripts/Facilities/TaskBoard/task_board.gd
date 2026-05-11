class_name JobBoard extends Node2D

var player_in_range : bool = false
@onready var notice: Label = $Notice
@onready var jobs_available_notice: Label = $JobsAvailableNotice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.new_jobs_available:
		jobs_available_notice.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		PlayerHudSignalBus.spawn_job_board_menu.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		notice.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()
