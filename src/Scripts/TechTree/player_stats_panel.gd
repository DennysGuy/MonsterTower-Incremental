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
	Attack Damage: %s
	Crit Chance: %s
	Crit Damage: %s
	Max Health: %s
	Movement Speed: %s"	% [
		PlayerStats.player_stats["Attack Damage"],
		PlayerStats.player_stats["Crit Chance"],
		PlayerStats.player_stats["Crit Damage"],
		PlayerStats.player_stats["Max Health"],
		PlayerStats.player_stats["Movement Speed"]
		]
	
