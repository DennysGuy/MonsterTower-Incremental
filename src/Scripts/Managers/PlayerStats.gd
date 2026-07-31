extends Node
class_name PlayerStatsSingleton

#global stat buff modifiers
var attack_buff_mod : float = 1.0
var crit_chance_buff_mod : float = 0.0
var crit_damage_buff_mod : float = 1.0
var defense_buff_mod : float = 1.0
var health_buff_mod : float = 0.0
var knock_back_buff_mod : float = 1.0
var move_speed_buff_mod : float = 0.0
var cool_down_speed_buff_mod : float = 0.0
var dodge_chance_buff_mod : float = 0.0 # not a thing a yet

const KNOCKBACK_FORCE : int = 100
const BASE_TRANSFER_TIME : float = 2.0
@onready var player_stats : Dictionary = {
	"Level" : 1,
	"Needed XP": 100,
	"Current XP" : 0,
	"Bonus XP" : 0,
	"Bonus AP" : 0,
	"Highest Floor": 0,
	"Ability Points": 0,
	"Max Jobs Held": 3,
	"Class": "Junior Hunter",
	"Tracked Weapon": 0,
	"Attack Damage" : 13.0,
	"Boss Damage Bonus": 0.0,
	"HP Siphen Amount": 0.2,
	"HP Siphen Chance": 0.0,
	"Insta Kill Chance": 0.0,
	"Insta Kill Threshold": 0.0,
	"Last Breadth Threshold": 0.0,
	"Last Breadth Multiplier": 0.0,
	"MP Dodge Chance": 0.0,
	"Dodge Chance": 0.0,
	"Critical Cooking Chance": 0.0,
	"Critical Smelting Chance": 0.0,
	"Free Range Chance": 0.0,
	"Free Heat Chance": 0.0,
	"Range Threads": 1.0,
	"Furance Threads": 1.0,
	"Failed Cooking Value Bonus": 0.0,
	"Failed Smelting Value Bonus": 0.0,
	"Movement Speed" : 80.0,
	"Climbing Speed" : 60.0,
	"Stun Length": 1.0,
	"Stun Stacks": 1.0,
	"Dash Speed" : 350.0,
	"Dash Cooldown" : 2.0,
	"Dash Duration" : 0.2,
	"Ladder Dash Duration" : 0.15,
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
	"HP Recovery": 0.3,
	"MP Recovery" : 0.4,
	"Equipped Sword": -1,
	"Equipped Pickaxe": 0,
	"Overlapping Hits" : 1.0,
	"Bag": 1,
	"Ore Bag":2,
	"Max Bank Slots": 8,
	"Max Bag Stack": 6,
	"Max Ore Bag Stack": 4,
	"Max Bank Stack":15,
	"Cooking Speed": 0.15,
	"Smelting Speed": 0.15,
	"Mining Damage": 5,
	"Monster Cap Bonus": 0,
	"Expedition Time": 90.0,
	"Hunt Time": 30.0,
	"Cooking Drop Chance Bonus":0.0,
	"Cooking Accuracy Bonus":0.0,
	"Ore Drop Chance Bonus":0.0,
	"Smelting Accuracy Bonus":0.0,
	"Tier 1 Chest Spawn Rate": 0.05,
	"Tier 1 Gem Drop Rate":0.3,
	"Chalice Spawn Rate":0.20,
	"Vial Spawn Rate": 0.20,
	"Lock On Multiplier" : 1.25,
	"Combat Ability Cooldown Bonus": 0.0,
	"Mining Bolt Links" : 0.0,
	"Mining Bolt Chance": 0.0,
	"Multi Bolts": 1.0,
	"Mining Bolt Damage": 5.0,
	"Mining Bolt Crit Chance": 0.0,
	"Mining Bolt Distance": 250.0,
	"Pick Up Distance": 20.0,
	"Cooldown Reduction":0.0,
	"Extra Ore Drop Chance": 0.0,
	"Bulk Sell Transfer Speed": 1.5,
	"Market Sell Speed": 5.0,
	"Auto Sell Transfer Speed": 2.0,
	"Bulk Sell Slots": 1.0,
	"Bulk Sell Slot Stack":4.0,
	"Market Value Multiplier":1.0,
}

var equipped_abilities : Dictionary = {
	"Attack 1" : null, #sword swing 1
	"Attack 2" : null, #sword swing 2
	"Attack 3" : null, #sword swing 3
	"Dash" : null, #basic dash attack
	"Air Attack" : null, #basic air attack
	"Double Jump" : null, #basic double jump
	"Special Attack" : null, #Not Going to Be Used
	"Combat Ability 1": null,
	"Combat Ability 2": null,
	"Combat Ability 3": null,
	"Combat Ability 4": null
}

var equipped_gem_sockets : Dictionary = {
	0: null,
	1: null,
	2: null,
	3: null
}

func reset_gem_sockets() -> void:
	print(equipped_gem_sockets)
	for socket in equipped_gem_sockets.keys():
		equipped_gem_sockets[socket] = null
	
	SaveManager.save_equipped_gems_stones()

func get_total_gem_bonus(stat_bonus_name : String) -> float:
	var total : float = 0.0
	
	for index in range(get_current_sword().gem_stone_socket_count):
		var socket = get_gem_socket(index)
		if socket:
			var stat_bonus : float = socket.get_stat_bonus(stat_bonus_name)
			total += stat_bonus
	
	return total

func get_total_gem_attack_bonus() -> float:
	var total : float = 0.0
	for index in range(get_current_sword().gem_stone_socket_count):
		var socket = get_gem_socket(index)
		if socket:
			total += socket.total_attack_bonus()
	
	return total

func get_total_gem_defense_bonus() -> float:
	var total : float = 0.0
	for index in range(get_current_sword().gem_stone_socket_count):
		var socket = get_gem_socket(index)
		if socket:
			total += socket.total_defense_bonus()
	
	return total

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
	
	if selected_slot is String:
		selected_slot = load(selected_slot)
	
	return selected_slot

func get_equipped_abilities() -> Dictionary:
	return equipped_abilities

func equip_ability(player_class : String, ability_type : String) -> void:
	var ability : Ability = player_classes[player_class][ability_type]
	equipped_abilities[ability_type] = ability
	SaveManager.save_equipped_abilities()

func set_tracked_weapon_index(new_index : int) -> void:
	player_stats["Tracked Weapon"] = new_index
	SaveManager.save_player_stats()

@onready var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Junk-A-Tron" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Crafting Tab": false,
	"Bank": false,
	"Arial Slash" : false,
	"Dash": false,
	"Ladder Dash": false,
	"Double Jump" : false,
	"Gem Stone Station": false,
	"HP Chalice" : false,
	"MP Vial" : false,
	"Junk A Tron Auto Transfer": false
}

@onready var check_points_unlocked : Dictionary = {
	"Floor 1-1" : false,
	"Floor 1-2" : false,
	"Floor 1-3" : false,
	"Floor 1-4" : false,
	"Floor 1-5" : false,
	"Floor 1-6" : false,
}

var player_classes : Dictionary = {
	"Junior Hunter" : {
		"Attack 1": preload("uid://c5hss1iq5ontu"),
		"Attack 2": preload("uid://rbc7yawqcf3h"),
		"Attack 3": preload("uid://7qd8qvg4bf73"),
		"Air Attack": 	preload("uid://bukiike6rf6pl"),
		"Dash": preload("uid://b0lsgfuw8bp58"),
		"Double Jump": preload("uid://rgwunwula5mv"),
		"Special Attack": null
	},
	"Tyro" : {
		"Attack 1": preload("uid://c5hss1iq5ontu"),
		"Attack 2": preload("uid://rbc7yawqcf3h"),
		"Attack 3": preload("uid://7qd8qvg4bf73"),
		"Air Attack": 	preload("uid://bukiike6rf6pl"),
		"Dash": preload("uid://b0lsgfuw8bp58"),
		"Double Jump": preload("uid://rgwunwula5mv"),
		"Special Attack": preload("uid://cs0umnvsvjhnh"),
		"Combat Ability 1" : null,
		"Combat Ability 2" : null,
		"Combat Ability 3" : null,
		"Combat Ability 4" : null
	}
}


var class_ability_node_stats : Dictionary = {
	"Tyro" : {
		"Abilities": {
			0 : preload("uid://dm3c3phl6fkid"),
			1 : preload("uid://cjc20n6ld53u3"),
			2 : preload("uid://js4itkff48rn"),
			3 : preload("uid://b1tqtyjdmcrui")
		},
		"Stat Upgrades": {
			0 : preload("uid://b3q7teodj24vf"),
			1 : preload("uid://bwy0u7543td2u"),
			2 : preload("uid://5yci1c1l1tb2")
		}

	}
}

const BEGINNGER_SWORD_COUNT : int = 3

var show_cooking_station_unlock_animation : bool = false
var show_refinery_station_unlock_animation : bool = false
var show_gem_station_unlock_animation : bool = false
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
		3:
			return preload("uid://bdsjrsiakv2sh") #Iron Broad Sword
		4:
			return preload("uid://dol2r302p2e52") #Lurker's Rapier
		5:
			return preload("uid://xqsea58c1jqh") #Bronze Sword Shield
		_:
			return preload("uid://di3xaosm85tjx")#"Wooden Sword"

func get_next_sword() -> Sword:
	if player_stats["Equipped Sword"] < BEGINNGER_SWORD_COUNT:
		var next_sword : int = int(player_stats["Equipped Sword"])+1
		return get_sword(next_sword)
	return null
	
func check_item_in_tracked_sword_recipe(item : Item) -> bool:
	var tracked_weapon_index : int = PlayerStats.player_stats["Tracked Weapon"]
	
	if tracked_weapon_index == -1:
		return false
	
	if get_sword(tracked_weapon_index):
		var next_sword_recipe : CraftingRecipe = get_sword(tracked_weapon_index).recipe
		if next_sword_recipe:
			return InventoryManager.item_in_recipe(item,next_sword_recipe)
		else:
			return false
	return false

func get_current_sword() -> Sword:
	return get_sword(PlayerStats.player_stats["Equipped Sword"])

func can_craft_next_sword() -> bool:
	print(get_sword(int(player_stats["Equipped Sword"])+1))
	if int(player_stats["Equipped Sword"])+1 > BEGINNGER_SWORD_COUNT:
		return false
	var next_sword : Sword = get_sword(int(player_stats["Equipped Sword"])+1)
	
	var craft_amount : int = InventoryManager.calculate_quantity(next_sword.recipe)
	return craft_amount >= 1

func can_craft_weapon() -> bool:
	var weapon : Sword = get_sword(player_stats["Tracked Weapon"])
	var craft_amount : int = InventoryManager.calculate_quantity(weapon.recipe)
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
		4: return preload("uid://omnm6ywng6wn")
		5: return
		_: return preload("uid://cuwof21s5e74c")

func get_current_bag() -> ItemBag:
	return get_bag("Bag")

func upgrade_player_stat(stat_name : String, interval : float, node_type : TechTreeManager.TECH_NODE_TYPE) -> void:
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY or node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		facilities_unlocked[stat_name] = true
		print("stat name: %s is unclocked : %s" % [stat_name, facilities_unlocked[stat_name]])
		SaveManager.save_game()
		if stat_name == "Junk-A-Tron":
			show_cooking_station_unlock_animation = true
		elif stat_name == "Refinery Station":
			show_refinery_station_unlock_animation = true
		elif stat_name == "Gem Stone Station":
			show_gem_station_unlock_animation = true
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

func load_abilities() -> void:
	
	if SaveManager.current_save_game and SaveManager.current_save_game.player_stats["Class"] == "Junior Hunter":
		return
		
	var ability_names : Array[String] = ["Air Attack", "Dash", "Double Jump", "Special Attack", "Combat Ability 1", "Combat Ability 2", "Combat Ability 3", "Combat Ability 4"]

	for ability_name in ability_names:
		var equipped_ability : Ability = get_equipped_ability(ability_name)
		if equipped_ability:
			equipped_ability.load_stats()

func check_needed_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 5 and PlayerStats.facilities_unlocked["Dash"] and PlayerStats.facilities_unlocked["Arial Slash"] and PlayerStats.facilities_unlocked["Double Jump"]

func check_level_for_dojo() -> bool:
	return PlayerStats.player_stats["Level"] >= 5

func get_total_max_health() -> int:
	return player_stats["Max Health"] + get_current_sword().get_total_hp_bonus()

func get_total_max_mp() -> int:
	return player_stats["Max MP"]  + get_current_sword().get_total_mp_bonus()

func recover_hp(amount : int) -> void:
	var prev_hp : int = GameManager.current_player_health
	if GameManager.current_player_health > get_total_max_health():
		GameManager.current_player_health = get_total_max_health()
	else:
		GameManager.current_player_health += amount
		
	PlayerHudSignalBus.update_player_health.emit(prev_hp)
		
func recover_mp(amount : int) -> void:
	var prev_mp : int = GameManager.current_player_mp
	if GameManager.current_player_mp > get_total_max_mp():
		GameManager.current_player_mp = get_total_max_mp()
	else:
		GameManager.current_player_mp += amount
	
	PlayerHudSignalBus.update_player_mp.emit(prev_mp)
	
func reset_global_stat_buffs() -> void:
	attack_buff_mod = 1.0
	crit_chance_buff_mod = 0.0
	crit_damage_buff_mod = 1.0
	defense_buff_mod = 1.0
	health_buff_mod = 0.0
	knock_back_buff_mod = 1.0
	move_speed_buff_mod = 0.0
	cool_down_speed_buff_mod = 0.0
	dodge_chance_buff_mod  = 0.0 # not a thing a yet
