class_name BulkSaleSlot extends TextureRect

@export var item_icon: TextureRect
@export var texture_progress_bar: TextureProgressBar
const SELL_ITEM = preload("uid://dasd38kajjc2r")
@export var item : Item
@export var grand_market_position : Marker2D
@export var quantity_label : Label

var quantity : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_progress_bar.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if quantity <= 0:
		queue_free()
	else:
		texture_progress_bar.value += PlayerStats.player_stats["Market Sell Speed"]
		
		if texture_progress_bar.value >= texture_progress_bar.max_value:
			quantity -= 1
			sell_item()
			texture_progress_bar.value = 0
			quantity_label.text = "%s/%s" % [quantity, int(PlayerStats.player_stats["Bulk Sell Slot Stack"])]
		
func add_item(selected_item : Item) -> void:
	item = selected_item
	quantity += 1
	quantity_label.text = "%s/%s" % [quantity, int(PlayerStats.player_stats["Bulk Sell Slot Stack"])]
	texture_progress_bar.max_value = item.sell_time

func sell_item() -> void:
	GameManager.play_sfx(SELL_ITEM)
	TechTreeManager.currency += item.sell_value * PlayerStats.player_stats["Market Value Multiplier"]
	SaveManager.save_tech_tree_data()
	HubManager.check_for_node_purchase.emit()
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	damage_label.set_crit_bg()
	damage_label.label.text = "+%s Spirols" % item.sell_value
	damage_label.global_position = grand_market_position.global_position
	grand_market_position.get_parent().add_child(damage_label)
