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
	if PlayerStats.get_next_sword():
		var next_sword_recipe : CraftingRecipe = PlayerStats.get_next_sword().recipe
		InventoryManager.clear_grid_container(resource_list)
		for item_dict in next_sword_recipe.recipe_list:
			for item in item_dict.keys():
				var quantity_list_item : QuantityListItem = preload("uid://cq8n5gyropdxm").instantiate()
				quantity_list_item.icon.texture = item.shop_icon
				quantity_list_item.quantity_label.text = "x%s" % [item_dict[item]]
				resource_list.add_child(quantity_list_item)
			
