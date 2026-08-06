class_name NewAbilityUpgradeMenu extends Control

@onready var ability_nodes_h_box_container: HBoxContainer = $AbilityNodesHBoxContainer
@onready var stat_upgrades_nodes_h_box_container: HBoxContainer = $StatUpgradesNodesHBoxContainer
@onready var ap: Label = $AP
@onready var classname: Label = $ClassName

const NEW_WEAPON_CRAFTING_NOTICE_SCENE = preload("uid://bhd7f77giafvv")

@onready var ability_name: Label = $MarginContainer/Panel/DescriptionPanel/AbilityName
@onready var ability_level: Label = $MarginContainer/Panel/DescriptionPanel/AbilityLevel
@onready var ability_description: RichTextLabel = $MarginContainer/Panel/DescriptionPanel/DescriptionPanelContainer/AbilityDescription
@onready var current_stats: RichTextLabel = $MarginContainer/Panel/DescriptionPanel/StatsPanelContainer/CurrentStats
@onready var next_stats: RichTextLabel = $MarginContainer/Panel/DescriptionPanel/NextStatsContainer/NextStats
@onready var class_title: Label = $MarginContainer/Panel/ClassTitle


var stored_class_ability_node_stats : ClassAbilityNodeStats

func _ready() -> void:
	SignalBus.update_ap_label.connect(update_ap_label)
	AbilitiesMenuManager.active_ability_button_pressed.connect(update_active_ability_description_panel)
	class_title.text = "Tyro | Warrior"
	update_ap_label()

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
	CutsceneManager.enable_player_functionality()
	SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.AP)
	SignalBus.combat_class_menu_closed.emit()
	
	if GameManager.first_class_just_unlocked:
		Dialogic.start(NEW_WEAPON_CRAFTING_NOTICE_SCENE)
		
	if PlayerStats.player_stats["Ability Points"] <= 0:
		HubManager.hide_facility_notification.emit("Class Advance Center")
	
	PlayerHudSignalBus.hub_menu_exited.emit()
	await get_tree().create_timer(0.3).timeout
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func _on_close_button_button_up() -> void:
	close_out()


func update_active_ability_description_panel(ability_node_stats : ClassAbilityNodeStats) -> void:
	ability_name.text = ability_node_stats.ability_resource.ability_name
	ability_level.text = "Level %s/%s" % [ability_node_stats.current_upgrade_level, ability_node_stats.max_upgrade_level]
	stored_class_ability_node_stats = ability_node_stats


func _on_upgrade_button_button_up() -> void:
	pass # Replace with function body.
