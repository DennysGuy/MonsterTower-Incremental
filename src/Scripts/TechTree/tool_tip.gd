class_name ToolTip extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var node_title: Label
@export var current_benefits: Label
@export var description: RichTextLabel
@export var cost: Label

@onready var resources_list: GridContainer = $ToolTip/ResourcesList

@export var tech_node_stats : TechNodeStats
@onready var quantity_list: GridContainer = $ToolTip/OwnedList/QuantityList
@onready var owned_list: Panel = $ToolTip/OwnedList

var can_buy : String = "#008260"
var unlocked : String = "#68754B"
var locked : String = "#666A68"
@export var panel: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.update_tool_tip_info.connect(update_info)
	animation_player.play("SpawnIn")

	if tech_node_stats.materials_required.size() > 0:
		for ingredient in tech_node_stats.materials_required:
			var ingredient_menu_item : IngredientItem = preload("uid://dil4081ni1hb3").instantiate()
			for key in ingredient.keys():
				ingredient_menu_item.ingredient_icon.texture = key.shop_icon
				ingredient_menu_item.quantity.text = "%s x%s" % [key.item_name, ingredient[key]]
			
			resources_list.add_child(ingredient_menu_item)
		check_resource_quantity()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_tool_tip() -> void:
	animation_player.play("SpawnOut")

func update_info(total_bonus : float) -> void:
	node_title.text = "%s (%s/%s)" % [tech_node_stats.node_name,tech_node_stats.current_level,tech_node_stats.max_level]
	
	if tech_node_stats.upgrade_interval > 0 and tech_node_stats.upgrade_interval < 1.0:
		if tech_node_stats.current_level < tech_node_stats.max_level:
			current_benefits.text = str(total_bonus*100)+"% -> "+str(total_bonus*100+tech_node_stats.upgrade_interval*100)+"%"
		else:
			current_benefits.text = "+"+str(total_bonus*100)+"%"
	elif tech_node_stats.upgrade_interval >= 1.0:
		if tech_node_stats.current_level < tech_node_stats.max_level:
			current_benefits.text = "%s -> %s" % [int(total_bonus), int(total_bonus+tech_node_stats.upgrade_interval)]
		else:
			current_benefits.text = "+%s" %[int(total_bonus)]
	
	description.text = tech_node_stats.description
	cost.text = "%s Gold" % [tech_node_stats.currency_required]
	
	check_resource_quantity()

func check_resource_quantity() -> void:
	if tech_node_stats.materials_required.size() > 0:
		clear_owned_list()
		owned_list.show()
		for resource_dict in tech_node_stats.materials_required:
			var quantity_list_item : QuantityListItem = preload("uid://cq8n5gyropdxm").instantiate()
			for resource in resource_dict.keys():
				quantity_list_item.icon.texture = resource.shop_icon
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
				quantity_list_item.quantity_label.text = "x%s" % [quantity]
				
			quantity_list.add_child(quantity_list_item)
				

func clear_owned_list() -> void:
	for child in quantity_list.get_children():
		child.queue_free()
