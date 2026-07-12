class_name JunkInteractable extends Node2D

var offset_distance := 32.0
var junk_picked_up : bool = false
var is_sold : bool = false
var player : Player
var grand_market_position : Marker2D
var sell_threshold := 5.0
var sell_speed := 300.0
@export var item : Item
@export var icon : Sprite2D
const MOVE_TO_MARKET = preload("uid://ojrph7f6g0vw")
const HIT_THE_MARKET = preload("uid://drf7id40p4ubo")
var pick_up_distance : int
var base_y : float
var holder_offset : Vector2 = Vector2.ZERO
var t : float = 0.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var prev_item_interactable : JunkInteractable


var selected_leader : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	player = get_tree().get_first_node_in_group("Player")
	
	pick_up_distance = PlayerStats.player_stats["Pick Up Distance"]
	base_y = position.y
	
	animation_player.play("Spawn")
	if PlayerStats.facilities_unlocked["Junk A Tron Auto Transfer"]:
		grand_market_position = get_tree().get_first_node_in_group("GrandMarketPosition")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
		if junk_picked_up:
			if !is_sold:
				var offset = Vector2.LEFT * offset_distance

				if player.sprite.flip_h:
					offset = Vector2.RIGHT * offset_distance

				var target_pos = player.global_position + offset

				global_position = global_position.lerp(
					target_pos,
					10.0 * delta
				)
				
			elif is_sold and grand_market_position:
				var target_pos = grand_market_position.global_position
				var tween : Tween = create_tween()
				tween.tween_property(self, "global_position", target_pos, get_sell_time(int(PlayerStats.player_stats["Bulk Sell Transfer Speed"])))
				await tween.finished
				global_position = target_pos

				sell_item()
				
		if PlayerStats.facilities_unlocked["Junk A Tron Auto Transfer"]:
			if grand_market_position:
				var target_pos = grand_market_position.global_position
				var tween : Tween = create_tween()
				tween.tween_property(self, "global_position", target_pos, get_sell_time(int(PlayerStats.player_stats["Auto Sell Transfer Speed"])))
				global_position = global_position.move_toward(
				target_pos,
				sell_speed * delta
				)
				await tween.finished
				#global_position = target_pos
				sell_item()
				
func get_sell_time(move_speed : int) -> float:
	return max(0.01, PlayerStats.BASE_TRANSFER_TIME * pow(0.65, move_speed))

func sell_item() -> void:
	SignalBus.shake_camera.emit(1.0)
	var bulk_sale_menu : BulkSellerGrandMarketMenu = get_tree().get_first_node_in_group("BulkGrandMarketMenu")
	var bulk_slots : Array = bulk_sale_menu.grid_container.get_children()
	add_item_to_bulk_menu(bulk_sale_menu, bulk_slots)
	
	queue_free()


func add_item_to_bulk_menu(bulk_sale_menu : BulkSellerGrandMarketMenu, bulk_slots : Array) -> void:
	var successfully_added : bool = false
	if bulk_slots.is_empty():
		bulk_sale_menu.create_bulk_sale_slot(item)
		successfully_added = true
		HubManager.hide_facility_notification.emit("Bulk Seller")
	
	for slot in bulk_slots:
		var bulk_slot : BulkSaleSlot = slot
		if bulk_slot.item == item and bulk_slot.quantity < PlayerStats.player_stats["Bulk Sell Slot Stack"]:
			bulk_slot.add_item(item)
			successfully_added = true
			HubManager.hide_facility_notification.emit("Bulk Seller")
	if !successfully_added:
		bulk_sale_menu.create_bulk_sale_slot(item)
	
	GameManager.play_sfx(HIT_THE_MARKET,0.0,randf_range(0.8,1.2))


func set_to_sold(market_position: Marker2D) -> void:
	var bulk_sale_menu : BulkSellerGrandMarketMenu = get_tree().get_first_node_in_group("BulkGrandMarketMenu")
	var bulk_slots : Array = bulk_sale_menu.grid_container.get_children()
	if !can_add_to_bulk_menu(bulk_slots):
		print("NO CAN DO")
		return
	GameManager.play_sfx(MOVE_TO_MARKET)
	player.junk_picked_up.pop_front()
	is_sold = true
	grand_market_position = market_position
	SignalBus.novelty_invention_sold.emit()

func move_forward() -> void:
	if is_instance_valid(prev_item_interactable) and !is_sold:
		offset_distance = prev_item_interactable.offset_distance

func set_leader(leader : Node2D) -> void:
	if junk_picked_up:
		return
	
	selected_leader = leader
	junk_picked_up = true
	
	var dir = (global_position - selected_leader.global_position).normalized()
	var desired_pos = selected_leader.global_position + dir * offset_distance
	
	var tween : Tween = create_tween()
	tween.tween_property(self, "global_position", desired_pos, 0.2)
	await tween.finished
	
func can_add_to_bulk_menu(bulk_slots : Array) -> bool:
	var can_add : bool = false
	
	if bulk_slots.is_empty():
		can_add = true
	
	for slot in bulk_slots:
		var bulk_slot : BulkSaleSlot = slot
		if bulk_slot.item == item and bulk_slot.quantity < PlayerStats.player_stats["Bulk Sell Slot Stack"]:
			can_add = true
	
	if !can_add:
		if bulk_slots.size() < PlayerStats.player_stats["Bulk Sell Slots"]:
			return true
	
	return can_add

func set_junk_offset() -> void:
	if !is_sold:
		var index := player.junk_picked_up.size()
		offset_distance *= index
		if index >= 1:
			prev_item_interactable = player.junk_picked_up[index-1]
		player.junk_picked_up.append(self)
		print(player.junk_picked_up)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !junk_picked_up:
		set_junk_offset()
		junk_picked_up = true
