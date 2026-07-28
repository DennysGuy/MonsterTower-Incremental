class_name TechTreeMap extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CutsceneManager.show_tech_tree.connect(player_tech_tree_intro)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func player_tech_tree_intro() -> void:
	await get_tree().create_timer(0.15).timeout
	for node in get_tree().get_nodes_in_group("TechNodes"):
		await node.show_node()
		await get_tree().create_timer(0.05).timeout
