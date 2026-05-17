class_name GreySentinelActivationSwitch extends Node2D

@onready var graphic: Sprite2D = $Graphic
@onready var notice: Label = $Notice

var activated : bool = false
var player_in_range : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	graphic.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and not activated:
		activate_boss()
		activated = true
		notice.hide()


func activate_boss() -> void:
	graphic.frame = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if not activated:
			notice.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()
