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
	"Class": "Junior Hunter",
	"Attack Damage" : 10.0,
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
	"Max Health" : 35,
	"Max MP": 50,
	"Current Health":35,
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

#this will be loaded when we enter the tower entrance map or a map in and of itself
#save will be handled automatically when the player alters this in some way
#loaded when entering a space that requires this
@export var tower_entrance_data : Dictionary = {
	"Floor 1-1" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Kill Quota Hit": false
	},
	"Floor 1-2" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Kill Quota Hit": false
	},
	"Floor 1-3" : {
		"Number of Spawn Locations" : 0,
		"Campfires Reached": 0,
		"Kill Quota Hit": false
	},
	
}
#loadded when we hit "continue game"
@export var facilities_unlocked : Dictionary = {
	"Hunter License" : false,
	"Cooking Station" : false,
	"Crafting Station" : false,
	"Refinery Station" : false,
	"Bank": false,
	"Arial Slash" : false,
	"Dash Attack": false
}


@export var check_points_unlocked : Dictionary = {
	"Floor 1-1" : false,
	"Floor 1-2" : false,
	"Floor 1-3" : false
}


#this is all we really care about actually since nodes don't increase in price or intervals don't change
#we will have to iterate through every tech node when we launch the tech tree and update each node's state.
#we will have to also iterate through the dictionary in TechTreeManager and apply the levels there too
@export var tech_nodes : Dictionary = {
	"Hunter License" : {"Level":0, "Unlocked": true},
	"Attack 1" : {"Level":0, "Unlocked": false},
	"Attack 2" : {"Level":0, "Unlocked": false},
	"Arial Slash": {"Level":0, "Unlocked": false},
	"Accuracy 1": {"Level":0, "Unlocked": false},
	"Accuracy 2": {"Level":0, "Unlocked": false},
	"Crit Chance 1" : {"Level":0, "Unlocked": false},
	"Crit Chance 2": {"Level":0, "Unlocked": false},
	"Crit Damage 1" : {"Level":0, "Unlocked": false},
	"Crit Damage 2": {"Level":0, "Unlocked": false},
	"Movement 1" : {"Level":0, "Unlocked": false},
	"Movement 2" : {"Level":0, "Unlocked": false},
	"Climb Speed 1" : {"Level":0, "Unlocked": false},
	"Climb Speed 2": {"Level":0, "Unlocked": false},
	"Jump Height 1": {"Level":0, "Unlocked": false},
	"Jump Height 2":{"Level":0, "Unlocked": false},
	"Max HP 1": {"Level":0, "Unlocked": false},
	"Max HP 2": {"Level":0, "Unlocked": false},
	"Defense 1": {"Level":0, "Unlocked": false},
	"Defense 2":{"Level":0, "Unlocked": false},
	"Expedition Time 1": {"Level":0, "Unlocked": false},
	"Expedition Time 2": {"Level":0, "Unlocked": false},
	"Monster Cap 1": {"Level":0, "Unlocked": false},
	"Monster Cap 2": {"Level":0, "Unlocked": false},
	"Item Bag 1":{"Level":0, "Unlocked": false},
	"Item Bag 2":{"Level":0, "Unlocked": false},
	"Deeper Pockets 1":{"Level":0, "Unlocked": false},
	"Deeper Pockets 2":{"Level":0, "Unlocked": false},
	"Dash Attack":{"Level":0, "Unlocked": false},
	"Dash Attack Duration 1":{"Level":0, "Unlocked": false},
	"Banking": {"Level":0, "Unlocked": false},
	"Banking 2": {"Level":0, "Unlocked": false},
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
	"Invincibility Duration 1": {"Level":0, "Unlocked": false}
}

@export var equipped_abilities : Dictionary = {
	"Attack 1" : load("uid://c5hss1iq5ontu"), #sword swing 1
	"Attack 2" : load("uid://rbc7yawqcf3h"), #sword swing 2
	"Attack 3" : load("uid://7qd8qvg4bf73"), #sword swing 3
	"Dash Attack" : load("uid://b0lsgfuw8bp58"), #basic dash attack
	"Air Attack" : load("uid://bukiike6rf6pl"), #basic air attack
	"Special Attack" : null
}

#though should be setup at "continue game too"
@export var inventories : Dictionary = {
	"Inventory" : [], # all other items go here
	"Ore Inventory" : [], #send crafting items here
	"Bank": []
}
