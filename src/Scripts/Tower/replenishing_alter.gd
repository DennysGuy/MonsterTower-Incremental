class_name ReplenishingAlter extends Node2D

enum TYPE {HP, MP}
var type : TYPE = TYPE.HP
@export var full_texture : Texture2D
@export var emptied_texture : Texture2D

@onready var graphic: Sprite2D = $Graphic

const REPLENISHING_CHALICE_HP_EMPTY = preload("uid://c7i5u3tjajops")
const REPLENISHING_CHALICE_HP_FULL = preload("uid://cqgo1ndavekv1")

const MP_VIAL_EMPTY = preload("uid://dhah5euxlc36r")
const MP_VIAL_FULL = preload("uid://bj8yk31astdj3")
@onready var notice: Label = $Notice

var player_in_range : bool = false
var depleted : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_textures()
	graphic.texture = full_texture
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initialize_textures() -> void:
	match type:
		TYPE.HP:
			full_texture = REPLENISHING_CHALICE_HP_FULL
			emptied_texture = REPLENISHING_CHALICE_HP_EMPTY
		TYPE.MP:
			full_texture = MP_VIAL_FULL
			emptied_texture = MP_VIAL_EMPTY
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if !depleted:
			notice.text = "Press 'E' to Consume"
		else:
			notice.text = "Resources Exhausted."
		notice.show()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()
