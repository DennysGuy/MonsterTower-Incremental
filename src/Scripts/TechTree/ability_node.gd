class_name AbilityNode extends Control

const ABILITY_NODE_DISABLED = preload("uid://46gvbpulh5q6")
const ABILITY_NODE_ENABLED = preload("uid://cl08f7bqcyut1")
const ABILITY_NODE_PURCHASED = preload("uid://c42bc8lfwvlgy")
@onready var node_icon: TextureRect = $NodeIcon

@onready var node_base: TextureRect = $NodeBase

@export var ability_node_stats : ClassAbilityNodeStats
@onready var texture_button: TextureButton = $TextureButton
@onready var panel_marker: Marker2D = $PanelMarker
var stored_description_panel : AbilityDescriptionPanel

func _ready() -> void:
	TechTreeManager.check_if_can_purchase_node.connect(check_can_purchase_node)
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
		ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
			ability_node_stats.upgrade_ability_stats()
		ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
			ability_node_stats.upgrade_character_stats()
		ability_node_stats.NODE_TYPE.CLASS_ADVANCE:
			pass
			
	ability_node_stats.unlocked = true		
	deduct_ap()
	#check_can_purchase_node()
	TechTreeManager.check_if_can_purchase_node.emit()

func deduct_ap() -> void:
	PlayerStats.player_stats["Ability Points"] -= ability_node_stats.ap_cost
	LevelingManager.update_available_ap_label.emit()
	SaveManager.save_player_stats()
	
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


func _on_texture_button_mouse_entered() -> void:
	create_description_panel()


func _on_texture_button_mouse_exited() -> void:
	if stored_description_panel:
		stored_description_panel.queue_free()


func create_description_panel() -> void:
	var description_panel : AbilityDescriptionPanel = preload("uid://b3mhlshnkg8ds").instantiate()
	
	description_panel.title.text = ability_node_stats.node_name
	description_panel.ap_cost.text = "AP Cost: %s" % ability_node_stats.ap_cost
	match ability_node_stats.node_type:
		ability_node_stats.NODE_TYPE.ABILITY_UNLOCK:
			description_panel.type.text = "Ability"
		ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
			description_panel.type.text = "Ability Upgrade"
		ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
			description_panel.type.text = "Stat Boost"
	
	description_panel.description.text = ability_node_stats.description
	description_panel.position = panel_marker.position
	stored_description_panel = description_panel
	add_child(description_panel)
