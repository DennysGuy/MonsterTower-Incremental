class_name BulkSellerGrandMarketMenu extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/GridContainer
@export var grand_market_position : Marker2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_bulk_sale_slot(item_to_sell : Item) -> void:
	var bulk_sale_slot : BulkSaleSlot = preload("uid://cpmombbk46n1e").instantiate()
	bulk_sale_slot.grand_market_position = grand_market_position
	bulk_sale_slot.add_item(item_to_sell)
	bulk_sale_slot.item_icon.texture = item_to_sell.shop_icon
	grid_container.add_child(bulk_sale_slot)

func fade_in() -> void:
	animation_player.play("Spawn In")

func fade_out() -> void:
	animation_player.play("Spawn Out")
