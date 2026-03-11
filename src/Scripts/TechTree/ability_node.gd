class_name AbilityNode extends Control

const ABILITY_NODE_DISABLED = preload("uid://46gvbpulh5q6")
const ABILITY_NODE_ENABLED = preload("uid://cl08f7bqcyut1")
const ABILITY_NODE_PURCHASED = preload("uid://c42bc8lfwvlgy")
@onready var node_icon: TextureRect = $NodeIcon

@onready var node_base: TextureRect = $NodeBase

@export var ability_node_stats : ClassAbilityNodeStats
@onready var texture_button: TextureButton = $TextureButton

func _ready() -> void:
	node_icon.texture = ability_node_stats.icon
	check_can_purchase_node()
		

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func check_can_purchase_node() -> void:
	if ability_node_stats.unlocked:
		node_base.texture = ABILITY_NODE_PURCHASED
		texture_button.disabled = true
	else:
		if PlayerStats.player_stats["Ability Points"] >= ability_node_stats.ap_cost and has_resource_quantity():
			node_base.texture = ABILITY_NODE_ENABLED
			texture_button.disabled = false
		else:
			node_base.texture = ABILITY_NODE_DISABLED
			texture_button.disabled = true


func _on_texture_button_button_up() -> void:
	'''
	if we can purchase the node -
	we will check the type of node
	
	ABILITY_UNLOCK:
		- when purchased, we equip the ability based on [class][ability name]
	ABILITY_STAT_BOOST:
		- we find the ability node based on [class][ability name]
		= need to figure out a way to dynamically update stats
	CHARACTER_STAT_BOOST:
		- search the player stat dictionary for the stat names and apply stat boost
	CLASS_ADVANCE:
		- effectively does nothing but will unlock the next set of rows
	'''
	match ability_node_stats.node_type:
		ability_node_stats.NODE_TYPE.ABILITY_UNLOCK:
			PlayerStats.equipped_abilities[ability_node_stats.ability_category] = ability_node_stats.ability_resource
			SaveManager.save_equipped_abilities()
			ability_node_stats.unlocked = true
			
	check_can_purchase_node()
	
func has_resource_quantity() -> bool:
	if ability_node_stats.materials_required.is_empty():
		return true

	for resource in ability_node_stats.materials_required:
		for item in resource.keys():
			match item.item_type:
				item.ITEM_TYPE.CRAFTING:
					if InventoryManager.get_quantity(item, "Crafting Items") < resource[item]:
						return false
				item.ITEM_TYPE.COOKING:
					if InventoryManager.get_quantity(item, "Cooking Items") < resource[item]:
						return false
				item.ITEM_TYPE.ORE:
					if InventoryManager.get_quantity(item, "Ore") < resource[item]:
						return false
				item.ITEM_TYPE.USE:
					if InventoryManager.get_quantity(item, "Use") < resource[item]:
						return false
		
	return true
