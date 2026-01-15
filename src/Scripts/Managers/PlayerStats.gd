extends Node

'''
For now, we will hold the player stats in a global script
This should eventually be moved into something that is save-able like a custom resource.

This is for testing purposes

'''

const KNOCKBACK_FORCE : int = 300

@onready var player_stats : Dictionary[String,float] = {
	"Attack Damage" : 10.0,
	"Movement Speed" : 100.0,
	"Climbing Speed" : 75.0,
	"Jump Height" : 300.0,
	"Crit Chance" : 0.0,
	"Defense" : 0.0,
	"Crit Damage" : 1.5,
	"Accuracy" : 0.6,
	"Max Health" : 50,
	"Max MP": 50,
	"Equipped Sword": 0,
	"Overlapping Hits" : 1.0,
	"Bag": 1,
	"Max Bank Slots": 4,
	"Max Bag Stack": 4,
	"Max Bank Stack":6,
	"Cooking Speed": 0.1
}

@onready var facilities_unlocked : Dictionary[String, bool] = {
	"Tower Pass" : false,
	"Cooking Station" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Bank": false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_sword_name() -> String:
	match player_stats["Equipped Sword"]:
		0:
			return "Wooden Sword"
		_:
			return "Wooden Sword"

func get_bag() -> ItemBag:
	match int(player_stats["Bag"]):
		1: return preload("uid://cuwof21s5e74c")
		2: return preload("uid://mbne7hjkpnqi")
		_: return preload("uid://cuwof21s5e74c")

func upgrade_player_stat(stat_name : String, interval : float, node_type : TechTreeManager.TECH_NODE_TYPE) -> void:
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
		facilities_unlocked[stat_name] = true
		print("stat name: %s is unclocked : %s" % [stat_name, facilities_unlocked[stat_name]])
		
		if stat_name == "Cooking Station":
			SignalBus.unlock_cooking_station.emit()
		elif stat_name == "Refinery Station":
			SignalBus.unlock_refinery.emit()
		#we'll need a way to figure out how to iniate a cutscene showing unlock sequence
		return
	
	var stat = player_stats.get(stat_name)
	if stat == null:
		return
	
	if interval < 1.0:
		if stat_name == "Attack Damage" or stat_name == "Movement Speed":
			player_stats[stat_name] += int(interval * player_stats[stat_name])
		else:
			player_stats[stat_name] += interval
	else:
		player_stats[stat_name] += interval
		
	InventoryManager.update_inventory_bag.emit()
	TechTreeManager.update_player_stats.emit()
