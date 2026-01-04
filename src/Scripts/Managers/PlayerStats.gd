extends Node

'''
For now, we will hold the player stats in a global script
This should eventually be moved into something that is save-able like a custom resource.

This is for testing purposes

'''

var player_stats : Dictionary[String,float] = {
	"Attack Damage" : 10.0,
	"Movement Speed" : 100.0,
	"Jump Height" : 300.0,
	"Crit Chance" : 0.0,
	"Crit Damage" : 1.5,
	"Max Health" : 50,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func upgrade_player_stat(stat_name : String, interval : float) -> void:
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
		
	print("The stat %s is now %s" % [stat_name, player_stats[stat_name]])
	TechTreeManager.update_player_stats.emit()
