extends Node

'''
For now, we will hold the player stats in a global script
This should eventually be moved into something that is save-able like a custom resource.

This is for testing purposes

'''

const KNOCKBACK_FORCE : int = 300

@onready var player_stats : Dictionary = {
	"Level" : 1,
	"Needed XP": 100,
	"Current XP" : 0,
	"Class": "Junior Hunter",
	"Attack Damage" : 13.0,
	"Movement Speed" : 100.0,
	"Climbing Speed" : 65.0,
	"Dash Speed" : 350.0,
	"Dash Cooldown" : 2.0,
	"Dash Duration" : 0.3,
	"Invincibility Duration": 2.5,
	"Jump Height" : 270.0,
	"Crit Chance" : 0.0,
	"Defense" : 0.0,
	"Crit Damage" : 1.5,
	"Accuracy" : 0.6,
	"Max Health" : 60,
	"Max MP": 50,
	"Current Health":60,
	"Current MP": 50,
	"Equipped Sword": 0,
	"Equipped Pickaxe": 0,
	"Overlapping Hits" : 1.0,
	"Bag": 1,
	"Ore Bag":2,
	"Max Bank Slots": 4,
	"Max Bag Stack": 4,
	"Max Ore Bag Stack": 4,
	"Max Bank Stack":6,
	"Cooking Speed": 0.15,
	"Smelting Speed": 0.15,
	"Mining Damage": 5,
	"Monster Cap Bonus": 0,
	"Expedition Time": 0.0,
	"Cooking Drop Chance Bonus":0.0,
	"Cooking Accuracy Bonus":0.0,
	"Ore Drop Chance Bonus":0.0,
	"Smelting Accuracy Bonus":0.0
}

var equipped_abilities : Dictionary = {
	"Attack 1" : load("uid://c5hss1iq5ontu"), #sword swing 1
	"Attack 2" : load("uid://rbc7yawqcf3h"), #sword swing 2
	"Attack 3" : load("uid://7qd8qvg4bf73"), #sword swing 3
	"Dash Attack" : preload("uid://b0lsgfuw8bp58"), #basic dash attack
	"Air Attack" : load("uid://b0lsgfuw8bp58"), #basic air attack
	"Special Attack" : null
}

func equip_ability(ability : Ability, position : String) -> void:
	equipped_abilities[position] = ability

@onready var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Cooking Station" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Bank": false,
	"Arial Slash" : false,
	"Dash Attack": false
}

@onready var check_points_unlocked : Dictionary = {
	"Floor 1-1" : false,
	"Floor 1-2" : false,
	"Floor 1-3" : false
}

var player_classes : Dictionary = {
	"Junior Hunter" : {
		"Sword Attack 1 Name": load("uid://c5hss1iq5ontu"),
		"Sword Attack 2 Name": load("uid://rbc7yawqcf3h"),
		"Sword Attack 3 Name": load("uid://7qd8qvg4bf73"),
		"Air Attack": 	load("uid://bukiike6rf6pl"),
		"Dash Attack": preload("uid://b0lsgfuw8bp58"),
		"Special Attack": null
	}
}

const MAX_SWORD_COUNT := 3

var show_cooking_station_unlock_animation : bool = false
var show_refinery_station_unlock_animation : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_sword(sword_index : int = 0) -> Sword:
	match sword_index:
		0:
			return 	preload("uid://di3xaosm85tjx")#"Wooden Sword"
		1:
			return preload("uid://gj2gdethgc68")#"Shroom Fibre Blade"
		2:
			return preload("uid://hnq8o34pxm0h") #Bronze Fang Blade
		_:
			return preload("uid://di3xaosm85tjx")#"Wooden Sword"

func get_next_sword() -> Sword:
	if player_stats["Equipped Sword"] < MAX_SWORD_COUNT-1:
		var next_sword : int = int(player_stats["Equipped Sword"])+1
		return get_sword(next_sword)
	return null
	
func check_item_in_next_sword_recipe(item : Item) -> bool:
	if get_next_sword():
		var next_sword_recipe : CraftingRecipe = get_next_sword().recipe
		if next_sword_recipe:
			return InventoryManager.item_in_recipe(item,next_sword_recipe)
		else:
			return false
	return false


func can_craft_next_sword() -> bool:
	if int(player_stats["Equipped Sword"])+1 == MAX_SWORD_COUNT:
		return false
	var next_sword : Sword = get_sword(int(player_stats["Equipped Sword"])+1)
	
	var craft_amount : int = InventoryManager.calculate_quantity(next_sword.recipe)
	return craft_amount >= 1

func get_pickaxe_name() -> String:
	match player_stats["Equipped Pickaxe"]:
		0:
			return "Stone Pickaxe"
		1:
			return "Bronze Pickaxe"
		_:
			return "Stone Pickaxe"

func get_bag(bag : String) -> ItemBag:
	match int(player_stats[bag]):
		1: return preload("uid://cuwof21s5e74c")
		2: return preload("uid://mbne7hjkpnqi")
		3: return preload("uid://byikht2gbhthk")
		_: return preload("uid://cuwof21s5e74c")

func upgrade_player_stat(stat_name : String, interval : float, node_type : TechTreeManager.TECH_NODE_TYPE) -> void:
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
		facilities_unlocked[stat_name] = true
		print("stat name: %s is unclocked : %s" % [stat_name, facilities_unlocked[stat_name]])
		
		if stat_name == "Cooking Station":
			show_cooking_station_unlock_animation = true
		elif stat_name == "Refinery Station":
			show_refinery_station_unlock_animation = true
		#we'll need a way to figure out how to iniate a cutscene showing unlock sequence
		return
	
	var stat = player_stats.get(stat_name)
	if stat == null:
		return
	
	if interval < 1.0:
		if stat_name == "Attack Damage" or stat_name == "Movement Speed" or stat_name == "Jump Height" or stat_name == "Climbing Speed":
			player_stats[stat_name] += int(interval * player_stats[stat_name])
		else:
			player_stats[stat_name] += interval
	else:
		player_stats[stat_name] += interval
		
	InventoryManager.update_inventory_bag.emit()
	TechTreeManager.update_player_stats.emit()

func check_needed_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 8 and PlayerStats.facilities_unlocked["Dash Attack"] and PlayerStats.facilities_unlocked["Arial Slash"]

func check_level_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 8
