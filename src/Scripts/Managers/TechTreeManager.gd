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

@warning_ignore("unused_signal")
signal play_license_upgrade_sequence

@warning_ignore("unused_signal")
signal check_for_tech_node_purchases

var currency : int = 0
var current_prestige : int = 0

var current_upgrade_count : int = 0
var upgrade_count_to_prestige : int = 0

enum STAT_RELATION {COMBAT, SURVIVAL, TRAVERSAL, INVENTORY, COOKING, CRAFTING, LICENSE}
enum TECH_NODE_TYPE {ABILITY, FACILITY, CLASS_ABILITY}

@onready var tech_nodes : Dictionary = {
	"Hunter License" : 0,
	"Attack 1" : 0,
	"Attack 2" : 0,
	"Attack 3" : 0,
	"Attack 4" : 0,
	"Arial Slash":0,
	"Accuracy 1": 0,
	"Accuracy 2": 0,
	"Bonus AP 1": 0,
	"Bonus XP 1": 0,
	"Crit Chance 1" : 0,
	"Crit Chance 2": 0,
	"Crit Chance 3": 0,
	"Crit Chance 4": 0,
	"Crit Damage 1" : 0,
	"Crit Damage 2": 0,
	"Crit Damage 3": 0,
	"Crit Damage 4": 0,
	"Movement 1" : 0,
	"Movement 2" : 0,
	"Movement 3" : 0,
	"Climb Speed 1" : 0,
	"Climb Speed 2": 0,
	"Climb Speed 3": 0,
	"Jump Height 1":0,
	"Jump Height 2":0,
	"Jump Height 3":0,
	"Max HP 1":0,
	"Max HP 2": 0,
	"Max MP 1":0,
	"Max MP 2":0,
	"Defense 1": 0,
	"Defense 2":0,
	"Expedition Time 1": 0,
	"Expedition Time 2": 0,
	"Monster Cap 1": 0,
	"Monster Cap 2": 0,
	"Crafting Tab":0,
	"Item Bag 1":0,
	"Item Bag 2":0,
	"Item Bag 3":0,
	"Deeper Pockets 1":0,
	"Deeper Pockets 2":0,
	"Deeper Pockets 3":0,
	"Dash":0,
	"Dash Attack Duration 1":0,
	"Banking":0,
	"Banking 2":0,
	"Banking 3":0,
	"Junk-A-Tron V1":0,
	"Junk Drops 1": 0,
	"Junk Drops 2": 0,
	"Junk-A-Speedster 1":0,
	"Junk-A-Speedster 2":0,
	"Junk-A-Accuracy 1": 0,
	"Junk-A-Accuracy 2": 0,
	"Refinery Station":0,
	"Mining Bolt Chance 1": 0,
	"Mining Bolt Distance 1": 0,
	"Mining Bolt Chain 1": 0,
	"Mining Barrage 1": 0,
	"Mining Speed 1": 0,
	"Mining Speed 2": 0,
	"Refinery Speed 1": 0,
	"Refinery Speed 2": 0,
	"Refinery Accuracy 1": 0,
	"Refinery Accuracy 2": 0,
	"Ore Drop Chance 1": 0.0,
	"Ore Drop Chance 2": 0.0,
	"Invincibility Duration 1":0.0,
	"Double Jump" : 0.0,
	"Tier 1 Gem Chest Rate Up": 0.0,
	"Tier 1 Gem Drop Rate Up": 0.0,
	"Vial of the Esoteric":0.0,
	"Chalice of Welfare":0.0,
	"Chalice Spawn Rate 1":0.0,
	"Vial Spawn Rate 1": 0.0,
	"Pick Up Range 1": 0.0,
	"Pick Up Range 2": 0.0,
	"Combat Cooldown 1": 0.0,
	"Combat Cooldown 2": 0.0,
	"XP Gain 1": 0.0,
	"XP Gain 2": 0.0,
	"AP Gain 1": 0.0,
	"AP Gain 2": 0.0,
	"Boss Damage 1": 0.0,
	"Insta Kill 1": 0.0,
	"Insta Kill Chance 1": 0.0,
	"Vampiric Siphen 1": 0.0,
	"Siphen Chance 1": 0.0,
	"Siphen Amount 1": 0.0,
	"Last Breadth 1": 0.0,
	"Breadth Threshold 1": 0.0,
	"MP Dodge 1": 0.0,
	"MP Dodge 2": 0.0,
	"Dodge Chance 1": 0.0,
	"Dodge Chance 2": 0.0,
	"Dash Distance 1": 0.0,
	"Dash Distance 2": 0.0,
	"Ladder Dash": 0.0,
	"Ladder Dash Distance 1": 0.0,
	"Critical Cooking 1": 0.0,
	"Critical Cooking 2": 0.0,
	"Critical Smelting 1": 0.0,
	"Critical Smelting 2": 0.0,
	"Free Range 1": 0.0,
	"Free Range 2": 0.0,
	"Free Heat 1": 0.0,
	"Free Heat 2": 0.0,
	"Range Threads 1": 0.0,
	"Polished Turd 1": 0.0,
	"Polished Turd 2": 0.0,
	"Salvaged Junk 1": 0.0,
	"Salvaged Junk 2": 0.0,
	"Extra Ore 1": 0.0,
	"Extra Ore 2": 0.0,
	"Expert Marketeer 1": 0.0,
	"Pro Mover 1": 0.0,
	"Bulk Sale Slots 1": 0.0,
	"Bulk Sale Slots 2": 0.0,
	"Bulk Sale Slots 3": 0.0,
	"Bulk Sale Slot Stack 1": 0.0,
	"Bulk Sale Slot Stack 2": 0.0,
	"Bulk Sale Slot Stack 3": 0.0,
	"Auto Sell Transfer Speed 1": 0.0
}

@onready var warrior_tech_nodes : Dictionary = {
	
}

@onready var mage_tech_nodes : Dictionary = {
	
}

@onready var tech_node_stats : Dictionary[String, TechNodeStats] = {
	"Hunter License" : preload("uid://bpf2kexi3o22s"),
	"Attack 1" : preload("uid://1gmjr0davgp4"),
	"Attack 2" : preload("uid://bqgnafgyrs4m4"),
	"Attack 3" : preload("uid://drs3wurlptmym"),
	"Attack 4" : preload("uid://b218wsbjh7pyo"),
	#"Accuracy 1": preload("uid://by1j5ly8stwkj"),
	#"Accuracy 2": preload("uid://bbvm0eijtrrvg") ,
	"Bonus AP 1": preload("uid://crr0o1kpusnpn"),
	"Bonus XP 1": preload("uid://c5surf2owculw"),
	"Bulk Sale Slots 1": preload("uid://7moo103gixvj"),
	"Bulk Sale Slots 2": preload("uid://dsx0fccwrnval"),
	"Bulk Sale Slots 3": preload("uid://jgq47sewguxf"),
	"Bulk Sale Slot Stack 1": preload("uid://xjx3q184mwsu"),
	"Bulk Sale Slot Stack 2": preload("uid://cxkvc17ad8t5t"),
	"Bulk Sale Slot Stack 3": preload("uid://bd72e41vun0w"),
	"Crit Chance 1" : preload("uid://cmy8gsm0hbovg"),
	"Crit Chance 2": preload("uid://ll3jw1v5omml"),
	"Crit Chance 3": preload("uid://x04h2nhi8gdh"),
	"Crit Chance 4": preload("uid://5le7ds72absa"),
	"Crit Damage 1" : preload("uid://ttsaddae3bcr"),
	"Crit Damage 2": preload("uid://c6lrtgrld7bx1"),
	"Crit Damage 3": preload("uid://fr5bgjnd33a7"),
	"Crit Damage 4": preload("uid://xqghhbiwak01"),
	"Movement 1" : preload("uid://ds0j00mlqnf55"),
	"Movement 2" : preload("uid://hqgkc8c13u2a"),
	"Movement 3" : preload("uid://ohr0gxoujtw2"),
	"Climb Speed 1" : preload("uid://bvqw5l1mpu3ku"),
	"Climb Speed 2": preload("uid://cr15fmppvbijx"),
	"Climb Speed 3": preload("uid://ccrpjjv60pjoe"),
	"Jump Height 1": preload("uid://b4xw1euerb1ka"),
	"Jump Height 2": preload("uid://b4n8wh8pnsfi8"),
	"Jump Height 3": preload("uid://b4n8wh8pnsfi8"), #This currently stores Jump Height 2 for future ref
	"Max HP 1": preload("uid://u1y3eoe8hx2c"),
	"Max HP 2": preload("uid://c33bcx7wsq4vk"),
	"Max MP 1": preload("uid://bfmdlo0jy1xsd"),
	"Max MP 2": preload("uid://c4jfyjh5yjva4"),
	"Defense 1": preload("uid://dhp1t1qeeqmau"),
	"Defense 2": preload("uid://c5l21ge3ylc0e"),
	"Item Bag 1":preload("uid://c1ojmw7gy7o6"),
	"Item Bag 2":preload("uid://cygetk8cm8cn5"),
	"Item Bag 3":preload("uid://xskacmmk7mn4"),
	"Deeper Pockets 1": preload("uid://ct7a5kggupi55"),
	"Deeper Pockets 2":preload("uid://ydq2itcsk458"),
	"Deeper Pockets 3":preload("uid://blg1x38jfumy1"),
	#"Dash Attack Duration 1":preload("uid://ioelpq1d2fhp"),
	"Banking":preload("uid://cmbxvekbk2uxx"),
	"Banking 2":preload("uid://cqjeh0yqqse5c"),
	"Banking 3":preload("uid://c2do0e0poa4or"),
	"Junk-A-Tron V1": preload("uid://bb7206hq4ygo3"),
	"Junk Drops 1": preload("uid://b1txboikgk5si"),
	"Junk Drops 2": preload("uid://dldvhuc6qmg2p"),
	"Junk-A-Speedster 1":preload("uid://cud4tvd0agqm4"),
	"Junk-A-Speedster 2":preload("uid://c2amp16srnwin"),
	"Junk-A-Speedster 3":preload("uid://lp20uphsdukm"),
	"Junk-A-Accuracy 1": preload("uid://ub5h4g7g447"),
	"Junk-A-Accuracy 2": preload("uid://bl5fxhci5olcj"),
	"Refinery Station":preload("uid://peiyat841rxh"),
	"Mining Bolt Chance 1": preload("uid://bvv3ywp852v5r"),
	"Mining Bolt Distance 1": preload("uid://fuiustuvb4gn"),
	"Mining Bolt Chain 1": preload("uid://m6wlc2wayc45"),
	"Mining Barrage 1": preload("uid://8x4upyxso8h3"),
	"Mining Speed 1": preload("uid://ddxgheqee7kmy"),
	"Mining Speed 2": preload("uid://bx8jjaeia4dr5"),
	"Refinery Speed 1": preload("uid://c6cb7c8bqn7ow"),
	"Refinery Speed 2": preload("uid://bwka1lphbne68"),
	"Refinery Accuracy 1": preload("uid://licswcd54xsn"),
	"Refinery Accuracy 2": preload("uid://4tjkp1pv61k7"),
	"Ore Drop Chance 1": preload("uid://ctf4we33chvvs"),
	"Ore Drop Chance 2": preload("uid://cdkycgvvwr38c"),
	"Tier 1 Gem Chest Rate Up": preload("uid://b6b483q551evk"),
	"Tier 1 Gem Drop Rate Up": preload("uid://c03qaydx74usi"),
	"Vial of the Esoteric":preload("uid://ddb4njdi5p43s"),
	"Chalice of Welfare":preload("uid://bp52qf07dd217"),
	"Chalice Spawn Rate 1":preload("uid://evdy54fep77a"),
	"Vial Spawn Rate 1": preload("uid://dnjct1360g838"),
	"Pick Up Range 1": preload("uid://g0ygkxkfllsh"),
	"Pick Up Range 2": preload("uid://bxsrojy06sgui"),
	"Combat Cooldown 1": preload("uid://bm30rm3kedvsp"),
	"Combat Cooldown 2": preload("uid://bslp1vf8jqc7n"),
	"XP Gain 1": preload("uid://dca38k23f8qdg"),
	"XP Gain 2": preload("uid://da5cfk33w53a7"),
	"AP Gain 1": preload("uid://c3puqbrn253v0"),
	"AP Gain 2": preload("uid://dto7io7l82yyq"),
	"Boss Damage 1": preload("uid://bqs24c70y86cp"),
	"Insta Kill 1": preload("uid://coviifivetye5"),
	"Insta Kill Chance 1": preload("uid://cvy8gppv7scd"),
	"Vampiric Siphen 1": preload("uid://8hkjeagafmg2"),
	"Proficient Vendor 1": preload("uid://df5ffuqkycbnv"),
	"Proficient Vendor 2": preload("uid://bv1k0gu2j2aeo"),
	"Siphen Chance 1": preload("uid://cmjrkltv1tvv7"),
	"Siphen Amount 1": preload("uid://doyqag11dkuft"),
	#"Last Breadth 1": preload("uid://dant3bywg07u"),
	#"Breadth Threshold 1": preload("uid://s42rn6aklaui"),
	#"MP Dodge 1": preload("uid://chuy1qutjtk58"),
	#"MP Dodge 2": preload("uid://b3otkclya332q"),
	"Dodge Chance 1": preload("uid://b6uimiiq8ow5u"),
	"Dodge Chance 2": preload("uid://ctjnncini5jvl"),
	"Dash Distance 1": preload("uid://ioelpq1d2fhp"),
	"Dash Distance 2": preload("uid://b6a033jtmxfu3"),
	"Crit-A-Tron 1": preload("uid://qxgigmr20cqm"),
	"Crit-A-Tron 2": preload("uid://cn6qldo3t53g7"),
	"Critical Smelting 1": preload("uid://c8v6iimoi7wcr"),
	"Critical Smelting 2": preload("uid://bqx6q34qvy3hj"),
	"Pro Mover 1": preload("uid://bjgwlyybfrnxd"),
	"Junk-A-Auto-Transfer": preload("uid://denk83487dyny"),
	"Auto Sell Transfer Speed 1": preload("uid://c3dg2fxa12pr6"),
	"Expert Marketeer 1": preload("uid://p0w0h82t37py"),
	"Ladder Dash": preload("uid://bfcnex03bip3y"),
	"Ladder Dash Distance 1": preload("uid://chr1ynm2qbnps")

	#"Free Range 1": preload("uid://bpdjvl0vrhdpa"),
	#"Free Range 2": preload("uid://i8atxfm76kuo"),
	#"Free Heat 1": preload("uid://vg0n3dc6j08g"),
	#"Free Heat 2": preload("uid://b32ox2g2nto6q"),
	#"Range Threads 1": preload("uid://b7dcm5uxu82fc"),
	#"Polished Turd 1": preload("uid://c4ii23l6kfvu2"),
	#"Polished Turd 2": preload("uid://2lv0y4udpiss"),
	#"Salvaged Junk 1": preload("uid://dhii5eruldp31"),
	#"Salvaged Junk 2": preload("uid://by6cvwd7fgaqk"),
	#"Extra Ore 1": preload("uid://dgdtvjb0k5drs"),
	#"Extra Ore 2": preload("uid://bchhcemqyw4lq"),
}

var beginner_base_abilities : Dictionary[int, TechNodeStats] = {
	0 : preload("uid://burkenucbrobr"),
	1 : preload("uid://cq5drdy7t8gas"),
	2 : preload("uid://bonlosm00p4kf")
}

func check_if_can_purchase_base_ability() -> bool:
	for ability in beginner_base_abilities.keys():
		var selected_ability : TechNodeStats = beginner_base_abilities[ability]
		if PlayerStats.player_stats["Ability Points"] >= selected_ability.ap_required and !PlayerStats.facilities_unlocked[selected_ability.node_name]:
			return true
	
	return false

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
		TechTreeManager.play_license_upgrade_sequence.emit()

func upgrade_hunter_license() -> void:
	QuestManager.check_general_task_for_completion.emit("Upgrade Hunter License")
	current_prestige += 1
	PlayerStats.player_stats["Expedition Time"] += 30
	upgrade_count_to_prestige += 30
	current_upgrade_count = 0
	update_prestige_tier_label.emit()
	update_prestige_tier_progress_label.emit()
	SaveManager.save_tech_tree_data()

func get_tech_node_status(node_name : String) -> bool:
	return SaveManager.current_save_game.tech_nodes[node_name]["Unlocked"]
