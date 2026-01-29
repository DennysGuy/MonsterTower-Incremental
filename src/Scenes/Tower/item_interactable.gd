class_name ItemInteractable extends Node2D

@export var item : Item
@export var icon : Sprite2D

var player : Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0
@onready var sfx_player: SFXPlayer = $SfxPlayer
const PICKUP_ITEM = preload("uid://cjrrqc2534diu")

var can_pick_up : bool = false
var base_y : float
var t : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = position.y
	
	animation_player.play("Spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	if can_pick_up:
		global_position = global_position.move_toward(player.coin_purse.global_position,3.0)
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		if abs(global_position) == abs(player.coin_purse.global_position):
			if !sfx_player.playing:
				sfx_player.play_sfx(PICKUP_ITEM)
			await get_tree().create_timer(2.0).timeout
			queue_free()
	else:
		t += delta * hover_speed
		position.y = base_y + sin(t) * hover_height

func set_to_pick_up() -> void:
	if item is EnemyDrop:
		if item.item_type == item.ITEM_TYPE.ORE:
			can_pick_up = InventoryManager.add_item("Ore Inventory", item)
		else:
			can_pick_up = InventoryManager.add_item("Inventory", item)
	else:
		can_pick_up = InventoryManager.add_item("Inventory", item)
		
