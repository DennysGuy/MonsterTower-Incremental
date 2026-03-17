extends Node
class_name PlayerStatsSingleton
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
	"Ability Points": 0,
	"Class": "Junior Hunter",
	"Attack Damage" : 13.0,
	"Movement Speed" : 100.0,
	"Climbing Speed" : 65.0,
	"Stun Length": 1.0,
	"Stun Stacks": 1.0,
	"Dash Speed" : 350.0,
	"Dash Cooldown" : 2.0,
	"Dash Duration" : 0.3,
	"Invincibility Duration": 2.5,
	"Jump Height" : 270.0,
	"Double Jump Height": 540.0,
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
	"Max Bag Stack": 6,
	"Max Ore Bag Stack": 4,
	"Max Bank Stack":8,
	"Cooking Speed": 0.15,
	"Smelting Speed": 0.15,
	"Mining Damage": 5,
	"Monster Cap Bonus": 0,
	"Expedition Time": 90.0,
	"Hunt Time": 30.0,
	"Cooking Drop Chance Bonus":0.0,
	"Cooking Accuracy Bonus":0.0,
	"Ore Drop Chance Bonus":0.0,
	"Smelting Accuracy Bonus":0.0
}

var equipped_abilities : Dictionary = {
	"Attack 1" : null, #sword swing 1
	"Attack 2" : null, #sword swing 2
	"Attack 3" : null, #sword swing 3
	"Dash Attack" : null, #basic dash attack
	"Air Attack" : null, #basic air attack
	"Double Jump" : null, #basic double jump
	"Special Attack" : null,

}

var equipped_gem_sockets : Dictionary = {
	0: null,
	1: null,
	2: null,
	3: null
}

func equip_gem_to_socket(gem_stone : GemStone) -> bool:
	for socket_index in range(get_current_sword().gem_stone_socket_count):
		if equipped_gem_sockets[socket_index] == null:
			equipped_gem_sockets[socket_index] = gem_stone
			SaveManager.save_equipped_gems_stones()
			return true
	return false
	
func get_equipped_gem_sockets() -> Dictionary:
	return equipped_gem_sockets
	
func get_gem_socket(position : int) -> GemStone:
	return equipped_gem_sockets[position]

func get_equipped_ability(slot : String) -> Ability:
	var selected_slot = equipped_abilities[slot]
	
	#if selected_slot is String:
		#selected_slot = load(selected_slot)
	
	return selected_slot

func get_equipped_abilities() -> Dictionary:
	return equipped_abilities

func equip_ability(player_class : String, ability_type : String) -> void:
	var ability : Ability = player_classes[player_class][ability_type]
	equipped_abilities[ability_type] = ability
	SaveManager.save_equipped_abilities()

@onready var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Cooking Station" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Crafting Tab": false,
	"Bank": false,
	"Arial Slash" : false,
	"Dash Attack": false,
	"Double Jump" : false
}

@onready var check_points_unlocked : Dictionary = {
	"Floor 1-1" : false,
	"Floor 1-2" : false,
	"Floor 1-3" : false
}

var player_classes : Dictionary = {
	"Junior Hunter" : {
		"Attack 1": preload("uid://c5hss1iq5ontu"),
		"Attack 2": preload("uid://rbc7yawqcf3h"),
		"Attack 3": preload("uid://7qd8qvg4bf73"),
		"Air Attack": 	preload("uid://bukiike6rf6pl"),
		"Dash Attack": preload("uid://b0lsgfuw8bp58"),
		"Double Jump": preload("uid://rgwunwula5mv"),
		"Special Attack": null
	},
	"Tyro" : {
		"Attack 1": preload("uid://c5hss1iq5ontu"),
		"Attack 2": preload("uid://rbc7yawqcf3h"),
		"Attack 3": preload("uid://7qd8qvg4bf73"),
		"Air Attack": 	preload("uid://dcxiodvnbqgef"),
		"Dash Attack": preload("uid://c3llqiy2fb5n5"),
		"Double Jump": preload("uid://ctavgtgbvyp1w"),
		"Special Attack": preload("uid://cs0umnvsvjhnh")
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

func get_current_sword() -> Sword:
	return get_sword(PlayerStats.player_stats["Equipped Sword"])

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

func get_current_bag() -> ItemBag:
	return get_bag("Bag")

func upgrade_player_stat(stat_name : String, interval : float, node_type : TechTreeManager.TECH_NODE_TYPE) -> void:
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY or node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
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
		
	InventoryManager.update_inventory_bag.emit("Inventory")
	TechTreeManager.update_player_stats.emit()

func check_needed_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 5 and PlayerStats.facilities_unlocked["Dash Attack"] and PlayerStats.facilities_unlocked["Arial Slash"] and PlayerStats.facilities_unlocked["Double Jump"]

func check_level_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 5
