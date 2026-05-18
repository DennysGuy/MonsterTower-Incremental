class_name GreySentinelActivationSwitch extends Node2D

@onready var graphic: Sprite2D = $Graphic
@onready var notice: Label = $Notice
const ACTIVATION_SWITCH_PRESSED = preload("uid://y6m3e4h1exp5")

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
	SignalBus.shake_camera.emit(15)
	play_sfx(ACTIVATION_SWITCH_PRESSED)
	SignalBus.start_boss_fight.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if not activated:
			notice.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
