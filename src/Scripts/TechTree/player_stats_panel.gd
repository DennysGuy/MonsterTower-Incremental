class_name PlayerStatsPanel extends Panel

@onready var stats: RichTextLabel = $Stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TechTreeManager.update_player_stats.connect(update_player_stats)
	update_player_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_player_stats() -> void:
	stats.text = "
	Expedition Time: %s
	Attack Damage: %s
	Crit Chance: %s
	Crit Damage: %s
	Max Health: %s
	Movement Speed: %s
	Jump Height: %s
	Climbing Speed: %s
	Accuracy: %s
	Mining Damage: %s
	Monster Cap Bonus: %s"	% [
		PlayerStats.player_stats["Expedition Time"],
		PlayerStats.player_stats["Attack Damage"],
		int(PlayerStats.player_stats["Crit Chance"] * 100),
		int(PlayerStats.player_stats["Crit Damage"] * 100),
		PlayerStats.player_stats["Max Health"],
		PlayerStats.player_stats["Movement Speed"],
		PlayerStats.player_stats["Jump Height"],
		PlayerStats.player_stats["Climbing Speed"],
		int(PlayerStats.player_stats["Accuracy"] * 100),
		PlayerStats.player_stats["Mining Damage"],
		PlayerStats.player_stats["Monster Cap Bonus"]
		]
	
