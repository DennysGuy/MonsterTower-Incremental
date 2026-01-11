class_name ItemInteractable extends Node2D

@export var item : Item
@export var icon : Sprite2D

var player : Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0

var can_pick_up : bool = false
var base_y : float
var t : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = position.y
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("Spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * hover_speed
	position.y = base_y + sin(t) * hover_height
	if can_pick_up:
		global_position = global_position.move_toward(player.coin_purse.global_position,1.4)
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		if global_position == player.coin_purse.global_position:
			print(InventoryManager.inventories["Inventory"])
			queue_free()

func set_to_pick_up() -> void:
	can_pick_up = InventoryManager.add_item("Inventory", item)
