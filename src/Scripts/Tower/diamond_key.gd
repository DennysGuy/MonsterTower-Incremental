class_name BossDoorKey extends Node2D

var player : Player
var base_y : float
var t : float = 0.0
var picked_up : bool = false
var can_pick_up : bool = false
@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0

@export var graphic : Sprite2D

var destination_marker : Marker2D

const CARD_KEY = preload("uid://01x17w0hhe24")
const DIAMOND_KEY = preload("uid://fkodcpdfvhxr")
const FINAL_KEY = preload("uid://pd0ldbh81ids")

enum KEY_TYPE {DIAMOND, CARD, FINAL}
@export var key_type : KEY_TYPE = KEY_TYPE.DIAMOND

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match key_type:
		KEY_TYPE.DIAMOND:
			graphic.texture = DIAMOND_KEY
		KEY_TYPE.CARD:
			graphic.texture = CARD_KEY
		KEY_TYPE.FINAL:
			graphic.texture = FINAL_KEY
	
	base_y = graphic.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if player:
		global_position = global_position.move_toward(player.holder.global_position,2.8)
	
	if destination_marker:
		global_position = global_position.move_toward(destination_marker.global_position,2.0)


	if picked_up:
		t += delta * hover_speed
		graphic.position.y = base_y + sin(t) * hover_height
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.held_key == null and destination_marker == null and can_pick_up:
		picked_up = true
		player = body
		body.held_key = self

func set_as_diamond_key() -> void:
	key_type = KEY_TYPE.DIAMOND

func set_as_card_key() -> void:
	key_type = KEY_TYPE.CARD

func set_as_final_key() -> void:
	key_type = KEY_TYPE.FINAL

func go_to_key_lock(marker : Marker2D) -> void:
	player = null
	picked_up = false
	disable_pick_up()
	destination_marker = marker

func enable_can_pick_up() -> void:
	can_pick_up = true

func disable_pick_up() -> void:
	can_pick_up = false
