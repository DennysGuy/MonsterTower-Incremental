class_name NodeDescriptionBox extends Control

@export var node_title : Label
@export var current_benefits : Label
@export var description : RichTextLabel
@export var cost : RichTextLabel
@export var tech_node_stats : TechNodeStats
@export var license_promotion_notice : Panel
@onready var resources_list: GridContainer = $Panel/ResourcesList
@onready var resrouces_title: Label = $ResroucesTitle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.update_tool_tip_info.connect(update_info)
	

	
	populate_resources_needed_list()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_info(total_bonus : float) -> void:
	
	if tech_node_stats.node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY or tech_node_stats.node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		return
	
	var true_total_bonus : float = PlayerStats.player_stats[tech_node_stats.stat_name]
	
	node_title.text = "%s (%s/%s)" % [tech_node_stats.node_name,tech_node_stats.current_level,tech_node_stats.max_level]
	
	if tech_node_stats.upgrade_interval > 0 and tech_node_stats.upgrade_interval < 1.0:
		if tech_node_stats.current_level < tech_node_stats.max_level:
			current_benefits.text = str(true_total_bonus*100)+"% -> "+str(true_total_bonus*100+tech_node_stats.upgrade_interval*100)+"%"
		else:
			current_benefits.text = "+"+str(total_bonus*100)+"%"
	elif tech_node_stats.upgrade_interval >= 1.0:
		if tech_node_stats.current_level < tech_node_stats.max_level:
			current_benefits.text = "%s -> %s" % [int(true_total_bonus), int(true_total_bonus+tech_node_stats.upgrade_interval)]
		else:
			current_benefits.text = "+%s" %[int(true_total_bonus)]
	
	description.text = tech_node_stats.description
	if tech_node_stats.currency_required <= 0:
		cost.text = ""
	else:
		cost.text = "Spirols: %s/%s" % [TechTreeManager.currency,tech_node_stats.get_cost()]
	
	populate_resources_needed_list()

func close_out() -> void:
	#We'll also put some sort of animated outro here
	queue_free()

func populate_resources_needed_list() -> void:
	if tech_node_stats.materials_required.is_empty():
		resrouces_title.text = ""
	else:
		resrouces_title.text = "Resrouces Needed"
	InventoryManager.clear_grid_container(resources_list)
	if tech_node_stats.materials_required.size() > 0:
		for ingredient in tech_node_stats.materials_required:
			var resource_description_item : ResourceDescriptionItem = preload("uid://dx6ad5nq6p5kc").instantiate()
			for key in ingredient.keys():
				resource_description_item.icon.texture = key.shop_icon
				var quantity : int = get_amount_owned(key)
				if quantity >= ingredient[key]:
					resource_description_item.amount_needed.text = "[color=green]%s/%s[/color]" % [quantity, ingredient[key]]
				else:
					resource_description_item.amount_needed.text = "%s/%s" % [quantity, ingredient[key]]
					
			resources_list.add_child(resource_description_item)

func show_license_promotion_notice() -> void:
	license_promotion_notice.show()

func hide_license_promotion_notice() -> void:
	license_promotion_notice.hide()

func get_amount_owned(resource : Item) -> int:
	var quantity : int = 0
	match resource.item_type:
		resource.ITEM_TYPE.COOKING:
			quantity = InventoryManager.get_quantity(resource, "Cooking Items")
		resource.ITEM_TYPE.CRAFTING:
			quantity = InventoryManager.get_quantity(resource, "Crafting Items")
		resource.ITEM_TYPE.ORE:
			quantity = InventoryManager.get_quantity(resource, "Ore")
		resource.ITEM_TYPE.USE:
				quantity = InventoryManager.get_quantity(resource, "Use")
				
	return quantity
