class_name ToolTip extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var node_title: Label
@export var current_benefits: Label
@export var description: RichTextLabel
@export var cost: Label

@onready var resources_list: GridContainer = $ToolTip/ResourcesList

@export var tech_node_stats : TechNodeStats

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
