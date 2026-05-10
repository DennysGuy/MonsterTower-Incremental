class_name AbilityNode extends Control

const ABILITY_NODE_DISABLED = preload("uid://46gvbpulh5q6")
const ABILITY_NODE_ENABLED = preload("uid://cl08f7bqcyut1")
const ABILITY_NODE_PURCHASED = preload("uid://c42bc8lfwvlgy")
@onready var lock_panel: Panel = $LockPanel

@onready var lock_texture: TextureRect = $LockPanel/LockTexture
@export var ability_tree_row : AbilityTreeNodeRow
@onready var node_icon: TextureRect = $NodeIcon

@onready var node_base: TextureRect = $NodeBase
@onready var level_tracker: Label = $LevelTracker

@export var ability_node_stats : ClassAbilityNodeStats
@onready var texture_button: TextureButton = $TextureButton
@onready var panel_marker: Marker2D = $PanelMarker
var stored_description_panel : AbilityDescriptionPanel

var can_buy : String = "#008260"
var unlocked : String = "#68754B"
var locked : String = "#666A68"

var bg_color : String 
const UNLOCK_ABILITY_NODE = preload("uid://qk35b21hbmi0")

func _ready() -> void:
	load_purchased_status()
	TechTreeManager.check_if_can_purchase_node.connect(check_can_purchase_node)
	node_icon.texture = ability_node_stats.icon
	check_can_purchase_node()
		
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func check_can_purchase_node() -> bool:
	if ability_node_stats.current_upgrade_level >= ability_node_stats.max_upgrade_level:
		node_base.texture = ABILITY_NODE_PURCHASED
		bg_color = locked
		return false
	if PlayerStats.player_stats["Ability Points"] >= ability_node_stats.ap_cost and has_resource_quantity():
		node_base.texture = ABILITY_NODE_ENABLED
		texture_button.disabled = false
		bg_color = unlocked
		return true
	else:
		node_base.texture = ABILITY_NODE_DISABLED
		texture_button.disabled = true
		bg_color = locked
		
	return false

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
	
	increment_ability_level()
	
	match ability_node_stats.node_type:

		ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
			ability_node_stats.upgrade_ability_stats()
			
		ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
			ability_node_stats.upgrade_character_stats()
			
		ability_node_stats.NODE_TYPE.CLASS_ADVANCE:
			pass
			
	deduct_ap()
	unlock_node()
	
	#check_can_purchase_node()
	TechTreeManager.check_if_can_purchase_node.emit()

func deduct_ap() -> void:
	PlayerStats.player_stats["Ability Points"] -= ability_node_stats.ap_cost
	SignalBus.update_ap_label.emit()
	SaveManager.save_player_stats()

func increment_ability_level() -> void:
	var node_type : String = ability_node_stats.get_ability_type_name()
	SaveManager.current_save_game.ability_nodes[ability_node_stats.class_relation][node_type][ability_node_stats.node_name]["Level"] += 1
	
	ability_node_stats.current_upgrade_level = SaveManager.current_save_game.ability_nodes[ability_node_stats.class_relation][node_type][ability_node_stats.node_name]["Level"]
	
	if ability_node_stats.node_type == ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST and ability_node_stats.current_upgrade_level == 1:
		PlayerStats.equipped_abilities[ability_node_stats.ability_category] = ability_node_stats.ability_resource
		SignalBus.unlock_cool_down_wheel.emit(ability_node_stats.ability_resource)
		SaveManager.save_equipped_abilities()
	
	level_tracker.text = "[%s/%s]" % [ability_node_stats.current_upgrade_level, ability_node_stats.max_upgrade_level]
	
	SaveManager.save_game()

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
	if ability_node_stats.unlocked:
		description_panel.ap_cost.text = "Unlocked!"
	else:
		description_panel.ap_cost.text = "AP Cost: %s" % ability_node_stats.ap_cost
	
	description_panel.bg.color = bg_color
	match ability_node_stats.node_type:
		ability_node_stats.NODE_TYPE.ABILITY_UNLOCK:
			description_panel.type.text = "Ability"
			description_panel.stat_list.text = ""
		ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
			description_panel.type.text = "Ability Upgrade"
			description_panel.stat_list.text = ""
			display_stats_changes(description_panel, ability_node_stats.get_ability_modifiers())
		ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
			description_panel.type.text = "Stat Boost"
			description_panel.stat_list.text = ""
			display_stats_changes(description_panel, ability_node_stats.get_character_stat_modifiers())
	
	description_panel.description.text = ability_node_stats.description
	description_panel.position = panel_marker.position
	stored_description_panel = description_panel
	add_child(description_panel)

func display_stats_changes(description_panel : AbilityDescriptionPanel, stat_list : Dictionary) -> void:
	for stat in stat_list.keys():
		if not stat_list[stat] is Vector2 and stat_list[stat] != 0.0:
			if stat_list[stat] < 1.0:
				description_panel.stat_list.text += "+%"+str(int(stat_list[stat] * 100)) + " " + stat + "\n"
			elif stat_list[stat] >= 1.0:
				description_panel.stat_list.text += "+%s %s\n" % [int(stat_list[stat]), stat]
			elif stat_list[stat] > -1.0 and stat_list[stat] < 0.0:
					description_panel.stat_list.text += "+%"+str(int(stat_list[stat] * 100)) + " " + stat + "\n"
			else:
				description_panel.stat_list.text += "-%s %s\n" % [int(stat_list[stat]), stat]

func unlock_node() -> void:
	play_sfx(UNLOCK_ABILITY_NODE,3)
	ability_node_stats.unlocked = true
	var node_type : String = ability_node_stats.get_ability_type_name()
	SaveManager.current_save_game.ability_nodes[ability_node_stats.class_relation][node_type][ability_node_stats.node_name]["Unlocked"] = true
	SaveManager.save_game()

func load_purchased_status() -> void:
	var class_relation : String = ability_node_stats.class_relation
	var ability_type_name : String = ability_node_stats.get_ability_type_name()
	var node_name : String = ability_node_stats.node_name
	

	ability_node_stats.unlocked = SaveManager.current_save_game.ability_nodes[class_relation][ability_type_name][node_name]["Unlocked"]
	ability_node_stats.current_upgrade_level = SaveManager.current_save_game.ability_nodes[class_relation][ability_type_name][node_name]["Level"]
	
	level_tracker.show()
	if ability_node_stats.current_upgrade_level >= ability_node_stats.max_upgrade_level:
		level_tracker.text = "Max Level"
	else:
		level_tracker.text = "[%s/%s]" % [ability_node_stats.current_upgrade_level,ability_node_stats.max_upgrade_level]

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func get_node_type_name() -> String:
	if ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
		return "Ability Stat Boost"
	elif ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
		return "Character Stat Boost"
	
	return ""
