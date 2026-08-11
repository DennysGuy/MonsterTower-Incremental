class_name GameSave extends Resource


'''
TODO: We will add saves for classes as well

'''


@export var currency : int = 0
@export var current_prestige : int = 0
@export var current_upgrade_count : int = 0
@export var upgrade_count_to_prestige : int = 0


#default values - a new save file will populate with this
#loaded when we hit "continue
@export var player_stats : Dictionary = {
	"Level" : 1,
	"Needed XP": 100,
	"Current XP" : 0,
	"Bonus XP" : 0,
	"Bonus AP" : 0,
	"Max Jobs Held": 1,
	"Highest Floor": 0,
	"Ability Points": 0,
	"Class": "Junior Hunter",
	"Attack Damage" : 13.0,
	"Tracked Weapon": 0,
	"Boss Damage Bonus": 0.0,
	"HP Siphen Amount": 0.02,
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
	"Movement Speed" : 90.0,
	"Climbing Speed" : 50.0,
	"Stun Length": 1.0,
	"Stun Stacks": 1.0,
	"Dash Speed" : 350.0,
	"Dash Cooldown" : 2.0,
	"Dash Duration" : 0.2,
	"Ladder Dash Duration" : 0.15,
	"Invincibility Duration": 2.5,
	"Jump Height" : 270.0,
	"Double Jump Height": 400.0,
	"Crit Chance" : 0.0,
	"Defense" : 0.0,
	"Crit Damage" : 1.5,
	"Accuracy" : 0.6,
	"Max Health" : 50,
	"Max MP": 150,
	"Current Health":50,
	"Current MP": 150,
	"HP Recovery": 0.3,
	"MP Recovery" : 0.4,
	"Equipped Sword": -1,
	"Equipped Pickaxe": 0,
	"Overlapping Hits" : 1.0,
	"Bag": 1,
	"Ore Bag":2,
	"Max Bank Slots": 8,
	"Max Bag Stack": 4,
	"Max Ore Bag Stack": 4,
	"Max Bank Stack":10,
	"Cooking Speed": 0.15,
	"Smelting Speed": 0.15,
	"Mining Damage": 5,
	"Monster Cap Bonus": 0,
	"Expedition Time": 60.0,
	"Hunt Time": 30.0,
	"Cooking Drop Chance Bonus":0.0,
	"Cooking Accuracy Bonus":0.0,
	"Ore Drop Chance Bonus":0.0,
	"Smelting Accuracy Bonus":0.0,
	"Tier 1 Chest Spawn Rate": 0.18,
	"Tier 1 Gem Drop Rate":0.3,
	"Chalice Spawn Rate":0.12,
	"Vial Spawn Rate": 0.12,
	"Lock On Multiplier" : 1.25,
	"Combat Ability Cooldown Bonus": 0.0,
	"Mining Bolt Links" : 1.0,
	"Mining Bolt Chance": 0.0,
	"Multi Bolts": 1.0,
	"Mining Bolt Damage": 5.0,
	"Mining Bolt Crit Chance": 0.0,
	"Mining Bolt Distance": 250.0,
	"Pick Up Distance": 20.0,
	"Cooldown Reduction":0.0,
	"Extra Ore Drop Chance": 0.0,
	"Bulk Sell Transfer Speed": 1.0,
	"Market Sell Speed": 5.0,
	"Auto Sell Transfer Speed": 2.0,
	"Bulk Sell Slots": 1.0,
	"Bulk Sell Slot Stack":4.0,
	"Market Value Multiplier":1.0,
	"Misc Drop Reduction Multiplier": 0.0
}

#this will be loaded when we enter the tower entrance map or a map in and of itself
#save will be handled automatically when the player alters this in some way
#loaded when entering a space that requires this
@export var tower_entrance_data : Dictionary = {
	"Floor 1-1" : {
		"Number of Spawn Locations" : 1,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-2" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-3" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-4" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-5" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-6" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false,
		"Activation Switch Unlocked": false,
	},
	"Floor 1-7" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Times Entered": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false,
	},
	
}
#loadded when we hit "continue game"
@export var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Junk-A-Tron" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Crafting Tab": false,
	"Bank": false,
	"Arial Slash" : false,
	"Ladder Dash": false,
	"Dash": false,
	"Jump": false,
	"Double Jump": false,
	"Gem Stone Station": false,
	"HP Chalice" : false,
	"MP Vial" : false,
	"Junk A Tron Auto Transfer":false
}

@export var check_points_unlocked : Dictionary = {
	"Floor 1-1" : true,
	"Floor 1-2" : false,
	"Floor 1-3" : false,
	"Floor 1-4" : false,
	"Floor 1-5" : false,
	"Floor 1-6" : false,
	"Floor 1-7": false,
}

#this is all we really care about actually since nodes don't increase in price or intervals don't change
#we will have to iterate through every tech node when we launch the tech tree and update each node's state.
#we will have to also iterate through the dictionary in TechTreeManager and apply the levels there too
@export var tech_nodes : Dictionary = {
	"Hunter License" : {"Level":0, "Unlocked": true},
	"Attack 1" : {"Level":0, "Unlocked": true},
	"Attack 2" : {"Level":0, "Unlocked": false},
	"Attack 3" : {"Level":0, "Unlocked": false},
	"Attack 4" : {"Level":0, "Unlocked": false},
	"Arial Slash": {"Level":0, "Unlocked": true},
	"Accuracy 1": {"Level":0, "Unlocked": false},
	"Accuracy 2": {"Level":0, "Unlocked": false},
	"Bonus AP 1":{"Level":0, "Unlocked": false},
	"Bonus XP 1":{"Level":0, "Unlocked": false},
	"Bulk Sale Slots 1": {"Level":0, "Unlocked": false},
	"Bulk Sale Slots 2": {"Level":0, "Unlocked": false},
	"Bulk Sale Slots 3": {"Level":0, "Unlocked": false},
	"Bulk Sale Slot Stack 1": {"Level":0, "Unlocked": false},
	"Bulk Sale Slot Stack 2": {"Level":0, "Unlocked": false},
	"Bulk Sale Slot Stack 3":{"Level":0, "Unlocked": false},
	"Bulk Sell Transfer Speed":{"Level":1, "Unlocked": false},
	"Crit Chance 1" : {"Level":0, "Unlocked": false},
	"Crit Chance 2": {"Level":0, "Unlocked": false},
	"Crit Chance 3": {"Level":0, "Unlocked":false},
	"Crit Chance 4": {"Level":0, "Unlocked":false},
	"Crit Damage 1" : {"Level":0, "Unlocked": false},
	"Crit Damage 2": {"Level":0, "Unlocked": false},
	"Crit Damage 3": {"Level":0, "Unlocked": false},
	"Crit Damage 4": {"Level":0, "Unlocked":false},
	"Movement 1" : {"Level":0, "Unlocked": false},
	"Movement 2" : {"Level":0, "Unlocked": false},
	"Movement 3" : {"Level":0, "Unlocked": false},
	"Climb Speed 1" : {"Level":0, "Unlocked": false},
	"Climb Speed 2": {"Level":0, "Unlocked": false},
	"Climb Speed 3": {"Level":0, "Unlocked": false},
	"Jump Height 1": {"Level":0, "Unlocked": true},
	"Jump Height 2":{"Level":0, "Unlocked": false},
	"Max HP 1": {"Level":0, "Unlocked": true},
	"Max HP 2": {"Level":0, "Unlocked": false},
	"Max MP 1": {"Level":0, "Unlocked": false},
	"Max MP 2": {"Level":0, "Unlocked": false},
	"Defense 1": {"Level":0, "Unlocked": false},
	"Defense 2":{"Level":0, "Unlocked": false},
	"Defense 3":{"Level":0, "Unlocked": false},
	"Expedition Time 1": {"Level":0, "Unlocked": false},
	"Expedition Time 2": {"Level":0, "Unlocked": false},
	"Monster Cap 1": {"Level":0, "Unlocked": false},
	"Monster Cap 2": {"Level":0, "Unlocked": false},
	"Crafting Tab":{"Level":0, "Unlocked": false},
	"Item Bag 1":{"Level":0, "Unlocked": true},
	"Item Bag 2":{"Level":0, "Unlocked": false},
	"Item Bag 3":{"Level":0, "Unlocked": false},
	"Deeper Pockets 1":{"Level":0, "Unlocked": false},
	"Deeper Pockets 2":{"Level":0, "Unlocked": false},
	"Deeper Pockets 3":{"Level":0, "Unlocked": false},
	"Dash":{"Level":0, "Unlocked": true},
	"Dash Attack Duration 1":{"Level":0, "Unlocked": false},
	"Banking": {"Level":0, "Unlocked": false},
	"Banking 2": {"Level":0, "Unlocked": false},
	"Banking 3": {"Level":0, "Unlocked": false},
	"Junk-A-Tron V1": {"Level":0, "Unlocked": true},
	"Junk Drops 1": {"Level":0, "Unlocked": false},
	"Junk Drops 2": {"Level":0, "Unlocked": false},
	"Junk-A-Speedster 1":{"Level":0, "Unlocked": false},
	"Junk-A-Speedster 2":{"Level":0, "Unlocked": false},
	"Junk-A-Speedster 3":{"Level":0, "Unlocked": false},
	"Junk-A-Accuracy 1": {"Level":0, "Unlocked": false},
	"Junk-A-Accuracy 2": {"Level":0, "Unlocked": false},
	"Expert Marketeer 1": {"Level":0, "Unlocked": false},
	"Refinery Station":{"Level":0, "Unlocked": true},
	"Mining Speed 1": {"Level":0, "Unlocked": false},
	"Mining Speed 2": {"Level":0, "Unlocked": false},
	"Refinery Speed 1": {"Level":0, "Unlocked": false},
	"Refinery Speed 2": {"Level":0, "Unlocked": false},
	"Refinery Accuracy 1": {"Level":0, "Unlocked": false},
	"Refinery Accuracy 2": {"Level":0, "Unlocked": false},
	"Ore Drop Chance 1": {"Level":0, "Unlocked": false},
	"Ore Drop Chance 2": {"Level":0, "Unlocked": false},
	"Mining Bolt Chance 1": {"Level":0, "Unlocked": false},
	"Mining Bolt Distance 1": {"Level":0, "Unlocked": false},
	"Mining Bolt Chain 1": {"Level":0, "Unlocked": false}, 
	"Mining Barrage 1": {"Level":0, "Unlocked": false},
	"Invincibility Duration 1": {"Level":0, "Unlocked": false},
	"Double Jump": {"Level":0, "Unlocked": true},
	"Jump": {"Level":0, "Unlocked": true},
	"Gem Stone Station": {"Level":0, "Unlocked":false},
	"Tier 1 Gem Chest Rate Up":{"Level":0, "Unlocked": false},
	"Tier 1 Gem Drop Rate Up":{"Level":0, "Unlocked": false},
	"Chalice of Welfare":{"Level":0, "Unlocked": false},
	"Vial of the Esoteric":{"Level":0,"Unlocked": false},
	"Chalice Spawn Rate 1": {"Level":0,"Unlocked": false},
	"Vial Spawn Rate 1": {"Level":0,"Unlocked": false},
	"Pick Up Range 1": {"Level":0,"Unlocked": false},
	"Pick Up Range 2": {"Level":0,"Unlocked": false},
	"Combat Cooldown 1": {"Level":0,"Unlocked": false},
	"Combat Cooldown 2": {"Level":0,"Unlocked": false},
	"XP Gain 1": {"Level":0,"Unlocked": false},
	"XP Gain 2": {"Level":0,"Unlocked": false},
	"AP Gain 1": {"Level":0,"Unlocked": false},
	"AP Gain 2": {"Level":0,"Unlocked": false},
	"Boss Damage 1": {"Level":0,"Unlocked": false},
	"Insta Kill 1": {"Level":0,"Unlocked": false},
	"Insta Kill Chance 1": {"Level":0,"Unlocked": false},
	"Vampiric Siphen 1": {"Level":0,"Unlocked": false},
	"Siphen Chance 1": {"Level":0,"Unlocked": false},
	"Siphen Amount 1": {"Level":0,"Unlocked": false},
	"Last Breadth 1": {"Level":0,"Unlocked": false},
	"Breadth Threshold 1": {"Level":0,"Unlocked": false},
	"MP Dodge 1": {"Level":0,"Unlocked": false},
	"MP Dodge 2": {"Level":0,"Unlocked": false},
	"Dodge Chance 1": {"Level":0,"Unlocked": false},
	"Dodge Chance 2": {"Level":0,"Unlocked": false},
	"Dash Distance 1": {"Level":0,"Unlocked": false},
	"Dash Distance 2": {"Level":0,"Unlocked": false},
	"Ladder Dash": {"Level":0,"Unlocked": false},
	"Ladder Dash Distance 1": {"Level":0,"Unlocked": false},
	"Crit-A-Tron 1": {"Level":0,"Unlocked": false},
	"Crit-A-Tron 2": {"Level":0,"Unlocked": false},
	"Critical Smelting 1": {"Level":0,"Unlocked": false},
	"Critical Smelting 2": {"Level":0,"Unlocked": false},
	"Free Range 1": {"Level":0,"Unlocked": false},
	"Free Range 2": {"Level":0,"Unlocked": false},
	"Free Heat 1": {"Level":0,"Unlocked": false},
	"Free Heat 2": {"Level":0,"Unlocked": false},
	"Range Threads 1": {"Level":0,"Unlocked": false},
	"Polished Turd 1": {"Level":0,"Unlocked": false},
	"Polished Turd 2": {"Level":0,"Unlocked": false},
	"Proficient Vendor 1": {"Level":0,"Unlocked": false},
	"Proficient Vendor 2": {"Level":0,"Unlocked": false},
	"Salvaged Junk 1": {"Level":0,"Unlocked": false},
	"Salvaged Junk 2": {"Level":0,"Unlocked": false},
	"Extra Ore 1": {"Level":0,"Unlocked": false},
	"Extra Ore 2": {"Level":0,"Unlocked": false},
	"Junk-A-Auto-Transfer":{"Level":0,"Unlocked": false},
	"Auto Sell Transfer Speed 1":{"Level":0,"Unlocked": false},
	"Pro Mover 1": {"Level":0,"Unlocked": false}
}

@export var equipped_abilities : Dictionary = {
	"Attack 1" : "uid://c5hss1iq5ontu", #sword swing 1
	"Attack 2" : "uid://rbc7yawqcf3h", #sword swing 2
	"Attack 3" : "uid://7qd8qvg4bf73", #sword swing 3
	"Dash" : "uid://b0lsgfuw8bp58" , #sword dance - for testing purposes
	"Air Attack" : "uid://bukiike6rf6pl", #sword slam - for testing purposes
	"Double Jump" : "uid://rgwunwula5mv", #sword soar - for testing purposes
	"Special Attack" : null, #double cleave - here for testing purposes,
	"Combat Ability 1" : null, #cyclone slash - for testing purposes
	"Combat Ability 2" : null, #Circle of Truth - for testing
	"Combat Ability 3" : null, #Iron Body for Testing
	"Combat Ability 4" : null, #Double Cleave for Testing
}

@export var abilities : Dictionary = {
	"Junior Hunter" : {
		"Dash" : {
			"Cooldown Time" : 1.5,
			"HP Cost" : 0.0,
			"MP Cost" : 0.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 1.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.6,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 1.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Air Attack": {
			"Cooldown Time" : 0.7,
			"HP Cost" : 0.0,
			"MP Cost" : 0.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 1.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 0.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Double Jump": {
			"Cooldown Time" : 0.3,
			"HP Cost" : 0.0,
			"MP Cost" : 0.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 0.0,
			"Max Hit Count": 0.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 0.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Special Attack": {
			"Cooldown Time" : 3.0,
			"HP Cost" :10.0,
			"MP Cost" : 12.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 1.0,
			"Max Hit Count": 2.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 2.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		}
	},
	"Tyro" : {##NEED TO ADD BUFF LIMIT TIME
		"Combat Ability 1" : {
			"Cooldown Time" : 6.0,
			"HP Cost" : 0.0,
			"MP Cost" : 13.0,
			"Base Attack": 50.0,
			"Number of Enemies Hit" : 10.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 2.0,
			"Stun Wait Time" : 2.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 1.25,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 2": {
			"Cooldown Time" : 7.0,
			"HP Cost" : 0.0,
			"MP Cost" : 15.0,
			"Base Attack": 15.0,
			"Number of Enemies Hit" : 0.0,
			"Max Hit Count": 0.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 3.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.3,
			"Move Speed Modifier" : 0.4,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 3": {
			"Cooldown Time" : 15.0,
			"HP Cost" : 0.0,
			"MP Cost" : 25.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 5.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 2.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 0.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 45.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 4": {
			"Cooldown Time" : 5.0,
			"HP Cost" :0.0,
			"MP Cost" : 16.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 1.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 2.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		}
	},
	"Scribe Assistant" : {##NEED TO ADD BUFF LIMIT TIME
		"Combat Ability 1" : {
			"Cooldown Time" : 6.0,
			"HP Cost" : 0.0,
			"MP Cost" : 6.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 10.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 2.0,
			"Stun Wait Time" : 2.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 1.5,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 2": {
			"Cooldown Time" : 7.0,
			"HP Cost" : 0.0,
			"MP Cost" : 15.0,
			"Base Attack": 15.0,
			"Number of Enemies Hit" : 0.0,
			"Max Hit Count": 0.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 3.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.3,
			"Move Speed Modifier" : 0.4,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 3": {
			"Cooldown Time" : 15.0,
			"HP Cost" : 0.0,
			"MP Cost" : 25.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 5.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 2.0,
			"Projectile Distance" : 0.0,
			"Slow Wait Time" : 0.0,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 45.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		},
		"Combat Ability 4": {
			"Cooldown Time" : 5.0,
			"HP Cost" :0.0,
			"MP Cost" : 16.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 1.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 2.0,
			"Move Speed Modifier" : 0.0,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0,
			"Knock Back Modifier" : 0.0,
			"Buff Limit Time": 0.0,
			"AOE Range": 0.0,
			"CC Time Limit": 0.0,
			"Up Time": 0.0
		}
	}
}

#though should be setup at "continue game too"
@export var inventories : Dictionary = {
	"Inventory" : [], # all other items go here
	"Ore" : [], #send crafting items here
	"Gem Stones" : [],
	"Use": [],
	"Bank": []
}

@export var ability_nodes : Dictionary = {
	"Tyro": {
		"Ability Stat Boost" : {
			"Double Cleave": {"Unlocked":false, "Level": 0},
			"Cyclone Slash": {"Unlocked":false, "Level": 0},
			"Circle of Truth": {"Unlocked":false, "Level": 0},
			"Iron Body": {"Unlocked":false, "Level": 0},
		},
		"Character Stat Boost" : {
			"Armored Core": {"Unlocked":false, "Level": 0},
			"Field Tactician" : {"Unlocked":false, "Level": 0},
			"Warrior's Flame" : {"Unlocked":false, "Level": 0},
		},
		"Class Advancement" : {
			
		}
	},
	"Scribe Assistant": {
		"Ability Stat Boost" : {
			"Piercer Ball": {"Unlocked":false, "Level": 0},
			"Arcane Mine": {"Unlocked":false, "Level": 0},
			"MP Siphon": {"Unlocked":false, "Level": 0},
			"Double Slash": {"Unlocked":false, "Level": 0},
		},
		"Character Stat Boost" : {
			"Armored Core": {"Unlocked":false, "Level": 0},
			"Field Tactician" : {"Unlocked":false, "Level": 0},
			"Warrior's Flame" : {"Unlocked":false, "Level": 0},
		},
		"Class Advancement" : {
			
		}
	}
}

@export var equipped_gem_sockets : Dictionary = {
	0: null,
	1: null,
	2: null,
	3: null
}

@export var active_quests : Dictionary = {
	"Main" : ["A Fresh Embarking"],
	"Job" : []
}

@export var quests : Dictionary = {
	0: {
		#Test Main quest 1
		"Status" : 0,
		"Turned In": false
	},
	1: {
		#Test Main quest 2
		"Status": 0,
		"Turned In": false
	},
	2: {
		#The Hunting Brave 1
		"Status": 0,
		"Turned In": false
	},
	3: {
		#The Apprentice Chef 1
		"Status": 0,
		"Turned In": false
	},
	4:{
		#Supplies for Our Comrades 1
		"Status": 0,
		"Turned In": false
	},
	5:{
		#The True Nature of the Tower 1
		"Status": 0,
		"Turned In": false
	},
	6:{
		#Avant Garde Alt. Medicine 1
		"Status": 0,
		"Turned In": false
	},
	7:{
		#A Fresh Embarking - Main Quest 1
		"Status": 1,
		"Turned In": false
	},
	8:{
		#Learning to Plunder - Main Quest 2
		"Status": 1,
		"Turned In": false
	},
	9:{
		#Getting Stronger
		"Status": 1,
		"Turned In": false
	},
	10:{
		#Tip of the Iceberg
		"Status": 1,
		"Turned In": false
	},
	11:{
		#Finding a Profession
		"Status": 1,
		"Turned In": false
	},
	12:{
		#Getting through the Dungeon
		"Status": 1,
		"Turned In": false
	},
	13:{
		#The Thick of it
		"Status": 1,
		"Turned In": false
	},
	14:{
		#Mystery's Emergence
		"Status": 1,
		"Turned In": false
	},
	15:{
		#Context Evolution
		"Status": 1,
		"Turned In": false
	},

}

@export var tasks : Dictionary = {
	0 : {
		#hunt shrubs
		"Current Count": 0,
		"Completed": false
	},
	1 : {
		#gather shurb cores 
		#don't need to keep track of count since count is determined by inventory
		"Completed": false
	},
	2: {
		#hit level 2
		"Completed": false
	},
	3: {
		#Hunt Batclopse
		"Current Count": 0,
		"Completed": false
	},
	4: {
		#Hunt Mushies
		"Current Count": 0,
		"Completed": false
	},
	5: {
		#mushie core gather
		"Completed": false
	},
	6: {
		#bat wing gather
		"Completed": false
	},
	7: {
		#30 Mushies Hunt
		"Current Count":0,
		"Completed": false
	},
	8:{
		#30 Batclopse Hunt
		"Current Count":0,
		"Completed": false
	},
	9:{
		#Gather 10 Gagootz
		"Completed": false
	},
	10:{
		#Gather 10 Mossy Goulash
		"Completed": false
	},
	11:{
		#Gather 10 Bronze Bars
		"Current Count":0,
		"Completed": false
	},
	12:{
		#Gather 10 Batclopse Claws
		"Current Count":0,
		"Completed": false
	},
	13:{
		#Gather 10 Mushie Fibers
		"Current Count":0,
		"Completed": false
	},
	14:{
		#Gather 10 Masks
		"Current Count":0,
		"Completed": false
	},
	15:{
		#Gather 25 Bat Wings
		"Current Count":0,
		"Completed": false
	},
	16: {
		#Gather 15 Bat Claws
		"Completed": false
	},
	17:{
		#Gather 20 Beetle Eyes
		"Current Count":0,
		"Completed": false
	},
	18:{
		#Gather 10 Beetle Claws
		"Current Count":0,
		"Completed": false
	},
	19:{
		#Gather 15 Beetle Shells
		"Current Count":0,
		"Completed": false
	},
	20:{
		#Gather 20 Purified Mushie Core
		"Current Count":0,
		"Completed": false
	},
	21:{
		#Gather 10 Serpant Tongues
		"Current Count":0,
		"Completed": false
	},
	22: {
		#Unlock Tower License
		"Completed": false
	},
	23: {
		#Enter the Tower
		"Completed": false
	},
	24: {
		#Enter Starspire
		"Completed": false
	},
	25: {
		#Enter the Grandmarket
		"Completed": false
	},
	26: {
		#Unlock Jump Height Node
		"Completed": false
	},
	27:{
		#One more run task
		"Completed": false
	},
	28:{
		#Reach Level 2 Task
		"Completed": false
	},
	29:{
		#Unlock Aerial Slash Node
		"Completed": false
	},
	30:{
		#Reach Floor 1-2
		"Completed": false
	},
	31:{
		#Upgrade Sword Once
		"Completed": false
	},
	32:{
		#Upgrade Hunters License Once
		"Completed": false
	},
	33:{
		#Unlock Cooking Station
		"Completed": false
	},
	34:{
		#Unlock Refinery Station
		"Completed": false
	},
	35:{
		#Reach Floor 1-3
		"Completed": false
	},
	36:{
		#Turn in a Job Request
		"Completed": false
	},
	37:{
		#Unlock All Base Abilities
		"Completed": false
	},
	38:{
		#Reach Level 8
		"Completed": false
	},
	39:{
		#Select a Class
		"Completed": false
	},
	40:{
		#Reach Floor 1-5
		"Completed": false
	},
	41:{
		#Reach Floor 1-6
		"Completed": false
	},
	42:{
		#Find the Door Activation Switch
		"Completed": false
	},
	43:{
		#Unlock the Boss Door
		"Completed": false
	},
	44:{
		#Defeat the Grey Sentinel
		"Completed": false
	},
	45: {
		#Open Monsterpedia Once
		"Completed": false
	},
	46: {
		#Open Recipe Book Once
		"Completed": false
	},
	47: {
		#Turn In a Job Request
		"Completed": false
	},
	48: {
		"Completed": false
	}
}

@export var weapon_status : Dictionary = {
	0: {"Unlocked":false, "Is Tracked": true},
	1: {"Unlocked":false, "Is Tracked": false},
	2: {"Unlocked":false, "Is Tracked": false},
	3: {"Unlocked":false, "Is Tracked": false},
	4: {"Unlocked":false, "Is Tracked": false},
	5: {"Unlocked":false, "Is Tracked": false},
}

@export var monster_unlock_status : Array = [
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
]

@export var bar_recipe_unlocks : Array = [
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
]

@export var dish_recipe_unlocks : Array = [
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
]

@export var progression_states : Dictionary = {
	"Market Intro Cutscene Played" : false,
	"First Class Just Unlocked": false,
	"First Quest Just Unlocked": false,
}

@export var various_settings : Dictionary = {
	"Monster Voices Toggled" : true,
	"Job Selection Notice Cutscene Played": false
}
