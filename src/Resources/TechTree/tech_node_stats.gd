class_name TechNodeStats extends Resource

@export var node_name : String
@export var icon : Texture2D
@export_multiline var description : String
@export var unlocked : bool = false
@export var max_level : int = 1
@export var current_level : int = 0
@export var currency_required : int = 0

@export_group("Player Stat Data")
@export var stat_name : String
@export var upgrade_interval : float = 0
'''
prereqs will be formatted as so 'node':'state'
i.e. attack I:1 -> attack I node at level 1 (or unlocked state)
i.e. food shop:true -> food shop node is unlocked

how things will be checked:
	- we loop through the list of pre reqs, parse the string
	- we will address tech node list to where we will find the name of the node and its state (dictionary 0(1) search)
'''

@export var prereqs : Array[String] 

'''
Now that we have node handling, we need to actually mutate the world in some way
- there are 2 ways the world can change from the tech tree
	- increasing player abilities
	- unlocking a new facility
'''
