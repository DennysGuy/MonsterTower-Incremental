class_name NewAbilityUpgradeMenu extends Control

@onready var ability_nodes_h_box_container: HBoxContainer = $AbilityNodesHBoxContainer
@onready var stat_upgrades_nodes_h_box_container: HBoxContainer = $StatUpgradesNodesHBoxContainer
@onready var ap: Label = $AP
@onready var classname: Label = $ClassName


func _ready() -> void:
	SignalBus.update_ap_label.connect(update_ap_label)
	classname.text = "~%s~" % PlayerStats.player_stats["Class"]
	update_ap_label()
	populate_node_container(ability_nodes_h_box_container,"Abilities")
	populate_node_container(stat_upgrades_nodes_h_box_container, "Stat Upgrades")

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func _physics_process(delta: float) -> void:
	pass


func populate_node_container(container : HBoxContainer, ability_list : String) -> void:
	var class_abilities : Dictionary = PlayerStats.class_ability_node_stats[PlayerStats.player_stats["Class"]][ability_list]
	for i in class_abilities.keys():
		var ability_node : AbilityNode = preload("uid://23brgcq8m6qb").instantiate()
		ability_node.ability_node_stats = class_abilities[i]
		container.add_child(ability_node)
	

func update_ap_label() -> void:
	ap.text = "AP: %s" % PlayerStats.player_stats["Ability Points"] 

func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_pause_game = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()


func _on_close_button_button_up() -> void:
	close_out()
