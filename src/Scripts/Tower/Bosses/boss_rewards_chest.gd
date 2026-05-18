class_name BossRewaredsChest extends Node2D

@export var rewards_list : Array[Item]
var player_in_range : bool = false
@onready var notice: Label = $Notice
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Fall")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		animation_player.play("Open")

func go_to_outro_screen() -> void:
	SignalBus.go_to_outro_screen.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		notice.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()
