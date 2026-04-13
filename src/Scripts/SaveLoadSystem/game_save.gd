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
	"Double Jump Height": 400.0,
	"Crit Chance" : 0.0,
	"Defense" : 0.0,
	"Crit Damage" : 1.5,
	"Accuracy" : 0.6,
	"Max Health" : 60,
	"Max MP": 200,
	"Current Health":60,
	"Current MP": 200,
	"HP Recovery": 0.3,
	"MP Recovery" : 0.4,
	"Equipped Sword": 0,
	"Equipped Pickaxe": 0,
	"Overlapping Hits" : 1.0,
	"Bag": 1,
	"Ore Bag":2,
	"Max Bank Slots": 4,
	"Max Bag Stack": 4,
	"Max Ore Bag Stack": 4,
	"Max Bank Stack":8,
	"Cooking Speed": 0.15,
	"Smelting Speed": 0.15,
	"Mining Damage": 5,
	"Monster Cap Bonus": 0,
	"Expedition Time": 30.0,
	"Hunt Time": 30.0,
	"Cooking Drop Chance Bonus":0.0,
	"Cooking Accuracy Bonus":0.0,
	"Ore Drop Chance Bonus":0.0,
	"Smelting Accuracy Bonus":0.0,
	"Tier 1 Chest Spawn Rate": 0.1,
	"Tier 1 Gem Drop Rate":0.3,
	"Chalice Spawn Rate":0.12,
	"Vial Spawn Rate": 0.12
}

#this will be loaded when we enter the tower entrance map or a map in and of itself
#save will be handled automatically when the player alters this in some way
#loaded when entering a space that requires this
@export var tower_entrance_data : Dictionary = {
	"Floor 1-1" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-2" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-3" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-4" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-5" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false
	},
	"Floor 1-6" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Hunt Challenge Unlocked": false,
		"Hunt Challenge Completed": false,
		"Activation Switch Unlocked": false,
	},
	
}
#loadded when we hit "continue game"
@export var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Cooking Station" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Crafting Tab": false,
	"Bank": false,
	"Arial Slash" : false,
	"Dash Attack": false,
	"Double Jump": false,
	"Gem Stone Station": false,
	"HP Chalice" : false,
	"MP Vial" : false
}

@export var check_points_unlocked : Dictionary = {
	"Floor 1-1" : false,
	"Floor 1-2" : false,
	"Floor 1-3" : false,
	"Floor 1-4" : false,
	"Floor 1-5" : false,
	"Floor 1-6" : false,
}


#this is all we really care about actually since nodes don't increase in price or intervals don't change
#we will have to iterate through every tech node when we launch the tech tree and update each node's state.
#we will have to also iterate through the dictionary in TechTreeManager and apply the levels there too
@export var tech_nodes : Dictionary = {
	"Hunter License" : {"Level":0, "Unlocked": true},
	"Attack 1" : {"Level":0, "Unlocked": false},
	"Attack 2" : {"Level":0, "Unlocked": false},
	"Attack 3" : {"Level":0, "Unlocked": false},
	"Attack 4" : {"Level":0, "Unlocked": false},
	"Arial Slash": {"Level":0, "Unlocked": true},
	"Accuracy 1": {"Level":0, "Unlocked": false},
	"Accuracy 2": {"Level":0, "Unlocked": false},
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
	"Jump Height 1": {"Level":0, "Unlocked": false},
	"Jump Height 2":{"Level":0, "Unlocked": false},
	"Max HP 1": {"Level":0, "Unlocked": false},
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
	"Item Bag 1":{"Level":0, "Unlocked": false},
	"Item Bag 2":{"Level":0, "Unlocked": false},
	"Item Bag 3":{"Level":0, "Unlocked": false},
	"Deeper Pockets 1":{"Level":0, "Unlocked": false},
	"Deeper Pockets 2":{"Level":0, "Unlocked": false},
	"Deeper Pockets 3":{"Level":0, "Unlocked": false},
	"Dash Attack":{"Level":0, "Unlocked": true},
	"Dash Attack Duration 1":{"Level":0, "Unlocked": false},
	"Banking": {"Level":0, "Unlocked": false},
	"Banking 2": {"Level":0, "Unlocked": false},
	"Banking 3": {"Level":0, "Unlocked": false},
	"Cooking Station": {"Level":0, "Unlocked": false},
	"Cooking Drops 1": {"Level":0, "Unlocked": false},
	"Cooking Drops 2": {"Level":0, "Unlocked": false},
	"Cooking Speed 1":{"Level":0, "Unlocked": false},
	"Cooking Speed 2":{"Level":0, "Unlocked": false},
	"Cooking Accuracy 1": {"Level":0, "Unlocked": false},
	"Cooking Accuracy 2": {"Level":0, "Unlocked": false},
	"Refinery Station":{"Level":0, "Unlocked": false},
	"Mining Speed 1": {"Level":0, "Unlocked": false},
	"Mining Speed 2": {"Level":0, "Unlocked": false},
	"Refinery Speed 1": {"Level":0, "Unlocked": false},
	"Refinery Speed 2": {"Level":0, "Unlocked": false},
	"Refinery Accuracy 1": {"Level":0, "Unlocked": false},
	"Refinery Accuracy 2": {"Level":0, "Unlocked": false},
	"Ore Drop Chance 1": {"Level":0, "Unlocked": false},
	"Ore Drop Chance 2": {"Level":0, "Unlocked": false},
	"Invincibility Duration 1": {"Level":0, "Unlocked": false},
	"Double Jump": {"Level":0, "Unlocked": true},
	"Gem Stone Station": {"Level":0, "Unlocked":false},
	"Tier 1 Gem Chest Rate Up":{"Level":0, "Unlocked": false},
	"Tier 1 Gem Drop Rate Up":{"Level":0, "Unlocked": false},
	"Chalice of Welfare":{"Level":0, "Unlocked": false},
	"Vial of the Esoteric":{"Level":0,"Unlocked": false},
	"Chalice Spawn Rate 1": {"Level":0,"Unlocked": false},
	"Vial Spawn Rate 1": {"Level":0,"Unlocked": false},
}

@export var equipped_abilities : Dictionary = {
	"Attack 1" : "uid://c5hss1iq5ontu", #sword swing 1
	"Attack 2" : "uid://rbc7yawqcf3h", #sword swing 2
	"Attack 3" : "uid://7qd8qvg4bf73", #sword swing 3
	"Dash Attack" : "uid://b0lsgfuw8bp58" , #sword dance - for testing purposes
	"Air Attack" : "uid://bukiike6rf6pl", #sword slam - for testing purposes
	"Double Jump" : "uid://rgwunwula5mv", #sword soar - for testing purposes
	"Special Attack" : null #double cleave - here for testing purposes
}

@export var abilities : Dictionary = {
	"Junior Hunter" : {
		"Dash Attack" : {
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
			"Dash Speed Modifier" : 1.0
		},
		"Air Attack": {
			"Cooldown Time" : 0.7,
			"HP Cost" : 0.0,
			"MP Cost" : 7.0,
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
			"Dash Speed Modifier" : 0.0
		},
		"Double Jump": {
			"Cooldown Time" : 0.5,
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
			"Dash Speed Modifier" : 0.0
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
			"Dash Speed Modifier" : 0.0
		}
	},
	"Tyro" : {
		"Dash Attack" : {
			"Cooldown Time" : 2.0,
			"HP Cost" : 0.0,
			"MP Cost" : 10.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 0.0,
			"Max Hit Count": 0.0,
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
			"Dash Speed Modifier" : 350.0
		},
		"Air Attack": {
			"Cooldown Time" : 1.5,
			"HP Cost" : 0.0,
			"MP Cost" : 7.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 0.0,
			"Max Hit Count": 0.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 0.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.3,
			"Move Speed Modifier" : 0.4,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0
		},
		"Double Jump": {
			"Cooldown Time" : 1.0,
			"HP Cost" : 0.0,
			"MP Cost" : 7.0,
			"Base Attack": 0.0,
			"Number of Enemies Hit" : 5.0,
			"Max Hit Count": 1.0,
			"Health Recovery" : 0.0,
			"MP Recovery" : 0.0,
			"Defense Modifier" : 0.0,
			"Projectile Distance" : 100.0,
			"Slow Wait Time" : 1.5,
			"Stun Wait Time" : 0.0,
			"Jump Height Modifier" : 100.0,
			"Climb Speed Modifier" : 0.0,
			"Attack Damage Modifier" : 0.5,
			"Move Speed Modifier" : 0.4,
			"Crit Damage Modifier" : 0.0,
			"Crit Chance Modifier" : 0.0,
			"Dash Cooldown" : 0.0,
			"Dash Speed Modifier" : 0.0
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
			"Dash Speed Modifier" : 0.0
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
		"Ability Unlock" : {
			"Double Cleave": {"Unlocked":false, "Level": 0},
			"Sword Dance": {"Unlocked":false, "Level": 0},
			"Sword Slam": {"Unlocked":false, "Level": 0},
			"Sword Soar": {"Unlocked":false, "Level": 0},
		},
		"Ability Stat Boost" : {
			"Double Cleave": {"Unlocked":false, "Level": 1},
			"Sword Dance": {"Unlocked":false, "Level": 1},
			"Sword Slam": {"Unlocked":false, "Level": 1},
		},
		"Character Stat Boost" : {
			"Armored Core 1": {"Unlocked":false, "Level": 0},
			"Field Tactician 1" : {"Unlocked":false, "Level": 0},
			"Warrior's Flame 1" : {"Unlocked":false, "Level": 0},
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

@export var class_ability_rows : Dictionary = {
	"Tyro" : {
		10 : {"Unlocked" : false,"Sigils Left": 0},
		12 : {"Unlocked" : false,"Sigils Left": 2},
		15 : {"Unlocked" : false,"Sigils Left": 0},
		17 : {"Unlocked" : false,"Sigils Left": 2},
		20 : {"Unlocked" : false,"Sigils Left": 0},
		22 : {"Unlocked" : false,"Sigils Left": 2},
		25 : {"Unlocked" : false,"Sigils Left": 0},
		27 : {"Unlocked" : false,"Sigils Left": 2},
		30 : {"Unlocked" : false,"Sigils Left": 0}
	}
		
}
