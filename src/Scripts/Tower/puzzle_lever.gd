class_name PuzzleLever extends Node2D

@onready var label: Label = $Label
var player_in_range : bool = false
var is_switched_on : bool = false
@onready var graphic: Sprite2D = $Graphic

const BLUE_LEVER_OFF = preload("uid://h24a46e83bq1")
const BLUE_LEVER_ON = preload("uid://crqkowlkiwxix")
const GREEN_LEVER_OFF = preload("uid://dk8csvewaqf8c")
const GREEN_LEVER_ON = preload("uid://dsycr3xhlsjnb")
const RED_LEVER_OFF = preload("uid://hnwkp82yi7qa")
const RED_LEVER_ON = preload("uid://c6r8p12680sw3")
const YELLOW_LEVER_OFF = preload("uid://c7ps2rrrm7rja")
const YELLOW_LEVER_ON = preload("uid://b04y24payxahl")
const LEVER_PULL = preload("uid://httoi7q6dybg")

enum SWITCH_COLOR {YELLOW, GREEN, RED, BLUE}
@export var switch_color : SWITCH_COLOR = SWITCH_COLOR.YELLOW

var on_texture : Texture2D
var off_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#we'll set on or off depending on if the puzzle has been solved
	set_switch_textures()
	graphic.texture = off_texture #we'll change this later to a signal
	SignalBus.reset_levers.connect(switch_off_lever)
	SignalBus.set_puzzle_levers_on.connect(switch_to_already_on)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and !is_switched_on:
		switch_on_lever()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !is_switched_on:
		player_in_range = true
		label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		label.hide()

func switch_on_lever() -> void:
	is_switched_on = true
	play_sfx(LEVER_PULL)
	send_lever_color_name()
	graphic.texture = on_texture

func switch_to_already_on() -> void:
	is_switched_on = true
	graphic.texture = on_texture
	
func switch_off_lever() -> void:
	is_switched_on = false
	graphic.texture = off_texture

func set_switch_textures() -> void:
	match switch_color:
		SWITCH_COLOR.YELLOW:
			on_texture = YELLOW_LEVER_ON
			off_texture = YELLOW_LEVER_OFF
		SWITCH_COLOR.GREEN:
			on_texture = GREEN_LEVER_ON
			off_texture = GREEN_LEVER_OFF
		SWITCH_COLOR.RED:
			on_texture = RED_LEVER_ON
			off_texture = RED_LEVER_OFF
		SWITCH_COLOR.BLUE:
			on_texture = BLUE_LEVER_ON
			off_texture = BLUE_LEVER_OFF

func send_lever_color_name() -> void:
	match switch_color:
		SWITCH_COLOR.YELLOW:
			SignalBus.send_lever_color_name.emit("Yellow")
		SWITCH_COLOR.GREEN:
			SignalBus.send_lever_color_name.emit("Green")
		SWITCH_COLOR.RED:
			SignalBus.send_lever_color_name.emit("Red")
		SWITCH_COLOR.BLUE:
			SignalBus.send_lever_color_name.emit("Blue")

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
