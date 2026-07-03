class_name ItemInteractable extends Node2D

@export var item : Item
@export var icon : Sprite2D
@export var perishable = true
@export var speed : float = 300
var player : Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MOVE_TO_MARKET = preload("uid://ojrph7f6g0vw")
const HIT_THE_MARKET = preload("uid://drf7id40p4ubo")

@export var hover_height : float = 6.0
@export var hover_speed : float = 2.0
@onready var sfx_player: SFXPlayer = $SfxPlayer
const PICKUP_ITEM = preload("uid://cjrrqc2534diu")

var offset_distance := 32.0
var can_pick_up : bool = false
var opt_to_pick_up : bool = false
var player_in_range : bool = false
var is_junk_drop : bool = false
var junk_picked_up : bool = false
var is_sold : bool = false
var base_y : float
var holder_offset : Vector2 = Vector2.ZERO
var t : float = 0.0
var grand_market_position : Marker2D
var sell_threshold := 5.0
var sell_speed := 300.0
# Called when the node enters the scene tree for the first time.
var pick_up_distance : int

var prev_item_interactable : ItemInteractable

func _ready() -> void:
	pick_up_distance = PlayerStats.player_stats["Pick Up Distance"]
	base_y = position.y
	
	animation_player.play("Spawn")
	if PlayerStats.facilities_unlocked["Junk A Tron Auto Transfer"]:
		grand_market_position = get_tree().get_first_node_in_group("GrandMarketPosition")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	#if player_in_range and Input.is_action_just_pressed("pan_cam_up"):
		#pick_up_item()

	if player.global_position.distance_to(global_position) <= pick_up_distance and opt_to_pick_up:
		pick_up_item()
		opt_to_pick_up = false
		
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
			can_pick_up = InventoryManager.add_item("Inventory", item)
		item.ITEM_TYPE.CRAFTING:
			can_pick_up = InventoryManager.add_item("Inventory", item)
		item.ITEM_TYPE.COOKING:
			can_pick_up = InventoryManager.add_item("Inventory", item)
		item.ITEM_TYPE.ORE:
			can_pick_up = InventoryManager.add_item("Ore", item)
		item.ITEM_TYPE.GEMSTONE:
			can_pick_up = InventoryManager.add_item("Gem Stones", item)
		item.ITEM_TYPE.USE:
			can_pick_up = InventoryManager.add_item("Use", item)
		
	if can_pick_up:
		SignalBus.play_sfx.emit(PICKUP_ITEM,0.0)
		PlayerHudSignalBus.populate_item_notification_panel.emit(item)
		if PlayerStats.can_craft_next_sword():
			HubManager.show_facility_notification.emit("Weapon Upgrade Station")
			SignalBus.show_can_craft_sword.emit()
		
		HubManager.check_for_node_purchase.emit()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#pick_up_item()
		player_in_range = true
		if is_junk_drop and !junk_picked_up and !PlayerStats.facilities_unlocked["Junk A Tron Auto Transfer"]:
			HubManager.show_facility_notification.emit("Bulk Seller")
			junk_picked_up = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false

func _on_destroy_timer_timeout() -> void:
	if perishable:
		queue_free()

func _on_pick_up_timer_timeout() -> void:
	opt_to_pick_up = true
