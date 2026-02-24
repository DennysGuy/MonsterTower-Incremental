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
var player_in_range : bool = false
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
			queue_free()
	else:
		t += delta * hover_speed
		position.y = base_y + sin(t) * hover_height

func set_to_pick_up() -> void:
	can_pick_up = true

func pick_up_item() -> void:
	match item.item_type:
		item.ITEM_TYPE.NOVELTY:
			can_pick_up = InventoryManager.add_item("Novelty Items", item)
		item.ITEM_TYPE.CRAFTING:
			can_pick_up = InventoryManager.add_item("Crafting Items", item)
		item.ITEM_TYPE.COOKING:
			can_pick_up = InventoryManager.add_item("Cooking Items", item)
		item.ITEM_TYPE.ORE:
			can_pick_up = InventoryManager.add_item("Ore", item)
		item.ITEM_TYPE.GEMSTONE:
			can_pick_up = InventoryManager.add_item("Gem Stones", item)
		item.ITEM_TYPE.USE:
			can_pick_up = InventoryManager.add_item("Use", item)
		
	if can_pick_up:
		SignalBus.play_sfx.emit(PICKUP_ITEM)
		SignalBus.populate_item_notification_panel.emit(item)
		if PlayerStats.can_craft_next_sword():
			SignalBus.show_can_craft_sword.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		pick_up_item()
