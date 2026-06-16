class_name SmithingStation extends Sprite2D


@onready var notification_icon: NotificationIcon = $NotificationIcon
@onready var resources_needed_panel: Panel = $ResourcesNeededPanel
@onready var resource_list: GridContainer = $ResourcesNeededPanel/ResourceList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.check_can_sword_craft.connect(notify_can_craft)
	SignalBus.update_resource_needed_panel.connect(populate_resource_needed_list)
	populate_resource_needed_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func notify_can_craft() -> void:
	if PlayerStats.can_craft_next_sword():
		notification_icon.set_new_notice_icon()
	else:
		notification_icon.hide_icon()

func populate_resource_needed_list() -> void:
	var tracked_index : int = PlayerStats.player_stats["Tracked Weapon"]
	if tracked_index <= -1:
		return
	
	if tracked_index == PlayerStats.BEGINNGER_SWORD_COUNT and PlayerStats.player_stats["Class"] == "Junior Hunter":
		return
	
	if  PlayerStats.get_sword(tracked_index):
		var next_sword_recipe : CraftingRecipe = PlayerStats.get_sword(PlayerStats.player_stats["Tracked Weapon"]).recipe
		InventoryManager.clear_grid_container(resource_list)
		for item_dict in next_sword_recipe.recipe_list:
			for item in item_dict.keys():
				var selected_item : Item = item
				var quantity_list_item : QuantityListItem = preload("uid://do7gmff4xat63").instantiate()
				var needed_quantity : int = item_dict[item]
				var current_quantity : int = InventoryManager.get_quantity(selected_item, selected_item.get_inventory_name())
				quantity_list_item.icon.texture = item.shop_icon
				if current_quantity >= needed_quantity:
					quantity_list_item.quantity_label.text = "[color=green]%s/%s[/color]" % [current_quantity,needed_quantity]
				else:
					quantity_list_item.quantity_label.text = "%s/%s" % [current_quantity,needed_quantity]
				resource_list.add_child(quantity_list_item)
			
