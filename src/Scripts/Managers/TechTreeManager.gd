extends Node

'''
For now, we will host dictionaries for nodes here for testing purposes
eventually this will be moved to a resource for saving purposes
'''
@warning_ignore("unused_signal")
signal check_node_prereqs

@warning_ignore("unused_signal")
signal update_prestige_tier_label

@warning_ignore("unused_signal")
signal update_prestige_tier_progress_label

@warning_ignore("unused_signal")
signal update_currency_label

@warning_ignore("unused_signal")
signal update_tool_tip_info(total_bonus : float)

@warning_ignore("unused_signal")
signal update_player_stats

@warning_ignore("unused_signal")
signal unlock_station

@warning_ignore("unused_signal")
signal check_if_can_purchase_node

@warning_ignore("unused_signal")
signal add_tool_tip(tool_tip : ToolTip, on_right_half : bool)

@warning_ignore("unused_signal")
signal save_node_data

@warning_ignore("unused_signal")
signal check_needed_item_panel_for_purchase

@warning_ignore("unused_signal")
signal set_ability_hud_icon

@warning_ignore("unused_signal")
signal check_if_can_show_class_select_node

@warning_ignore("unused_signal")
signal update_available_ap_label

var currency : int = 0
var current_prestige : int = 0

var current_upgrade_count : int = 0
var upgrade_count_to_prestige : int = 0


enum TECH_NODE_TYPE {ABILITY, FACILITY, CLASS_ABILITY}

@onready var tech_nodes : Dictionary = {
	"Hunter License" : 0,
	"Attack 1" : 0,
	"Attack 2" : 0,
	"Arial Slash":0,
	"Accuracy 1": 0,
	"Accuracy 2": 0,
	"Crit Chance 1" : 0,
	"Crit Chance 2": 0,
	"Crit Damage 1" : 0,
	"Crit Damage 2": 0,
	"Movement 1" : 0,
	"Movement 2" : 0,
	"Climb Speed 1" : 0,
	"Climb Speed 2": 0,
	"Jump Height 1":0,
	"Jump Height 2":0,
	"Max HP 1":0,
	"Max HP 2": 0,
	"Defense 1": 0,
	"Defense 2":0,
	"Expedition Time 1": 0,
	"Expedition Time 2": 0,
	"Monster Cap 1": 0,
	"Monster Cap 2": 0,
	"Crafting Tab":0,
	"Item Bag 1":0,
	"Item Bag 2":0,
	"Deeper Pockets 1":0,
	"Deeper Pockets 2":0,
	"Dash Attack":0,
	"Dash Attack Duration 1":0,
	"Banking":0,
	"Banking 2":0,
	"Cooking Station":0,
	"Cooking Drops 1": 0,
	"Cooking Drops 2": 0,
	"Cooking Speed 1":0,
	"Cooking Speed 2":0,
	"Cooking Accuracy 1": 0,
	"Cooking Accuracy 2": 0,
	"Refinery Station":0,
	"Mining Speed 1": 0,
	"Mining Speed 2": 0,
	"Refinery Speed 1": 0,
	"Refinery Speed 2": 0,
	"Refinery Accuracy 1": 0,
	"Refinery Accuracy 2": 0,
	"Ore Drop Chance 1": 0.0,
	"Ore Drop Chance 2": 0.0,
	"Invincibility Duration 1":0.0,
	"Double Jump" : 0.0
}

@onready var warrior_tech_nodes : Dictionary = {
	
}

@onready var mage_tech_nodes : Dictionary = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func check_prereq(node_state: String) -> bool:
	var data := node_state.split(":")
	if data.size() != 2:
		push_warning("Invalid prereq format: %s" % node_state)
		return false

	var key := data[0]
	var required := data[1].to_int()

	if not tech_nodes.has(key):
		return false

	var current := int(tech_nodes[key])
	return current >= required

func increment_upgrade_count() -> void:
	current_upgrade_count += 1
	update_prestige_tier_progress_label.emit()
	
	if current_upgrade_count >= upgrade_count_to_prestige:
		current_prestige += 1
		PlayerStats.player_stats["Hunt Time"] += 15
		PlayerStats.player_stats["Expedition Time"] += 20
		upgrade_count_to_prestige += 15
		current_upgrade_count = 0
		update_prestige_tier_label.emit()
		update_prestige_tier_progress_label.emit()
