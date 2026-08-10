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

@onready var warrior_passive_abilities_panel: Panel = $MarginContainer/Panel/WarriorPassiveAbilitiesPanel
@onready var warrior_active_abilities_panel: Panel = $MarginContainer/Panel/WarriorActiveAbilitiesPanel

@onready var upgrade_button: Button = $MarginContainer/Panel/DescriptionPanel/UpgradeButton

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
	var node_type : String = ability_node_stats.get_ability_type_name()
	var saved_node_data : Dictionary = SaveManager.current_save_game.ability_nodes[ability_node_stats.class_relation][node_type][ability_node_stats.node_name]
	ability_name.text = ability_node_stats.node_name
	ability_level.text = "Level %s/%s" % [saved_node_data["Level"], ability_node_stats.max_upgrade_level]
	stored_class_ability_node_stats = ability_node_stats
	ability_description.text = ability_node_stats.description
	
	match ability_node_stats.get_ability_type_name():
		"Ability Stat Boost":
			display_stats_changes(current_stats, ability_node_stats.get_ability_modifiers(), saved_node_data["Level"])
			if saved_node_data["Level"] < ability_node_stats.max_upgrade_level:
				display_stats_changes(next_stats, ability_node_stats.get_ability_modifiers(), saved_node_data["Level"]+1,false)
			else:
				next_stats.text = "Max Level Hit!"
		"Character Stat Boost":
			display_stats_changes(current_stats, ability_node_stats.get_character_stat_modifiers(), saved_node_data["Level"])
			if saved_node_data["Level"] < ability_node_stats.max_upgrade_level:
				display_stats_changes(next_stats, ability_node_stats.get_character_stat_modifiers(), saved_node_data["Level"]+1,false)
			else:
				next_stats.text = "Max Level Hit!"
			
	if saved_node_data["Level"] <= 0 and node_type == "Ability Stat Boost":
		upgrade_button.text = "Unlock"
	else:
		upgrade_button.text = "Upgrade"
	
	if PlayerStats.player_stats["Ability Points"] >= ability_node_stats.ap_cost:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true

func increment_ability_level() -> void:
	var node_type : String = stored_class_ability_node_stats.get_ability_type_name()
	var saved_node_data : Dictionary = SaveManager.current_save_game.ability_nodes[stored_class_ability_node_stats.class_relation][node_type][stored_class_ability_node_stats.node_name]
	saved_node_data["Level"] += 1
	
	stored_class_ability_node_stats.current_upgrade_level = SaveManager.current_save_game.ability_nodes[stored_class_ability_node_stats.class_relation][node_type][stored_class_ability_node_stats.node_name]["Level"]
	
	if stored_class_ability_node_stats.node_type == stored_class_ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST and stored_class_ability_node_stats.current_upgrade_level == 1:
		PlayerStats.equipped_abilities[stored_class_ability_node_stats.ability_category] = stored_class_ability_node_stats.ability_resource
		SignalBus.unlock_cool_down_wheel.emit(stored_class_ability_node_stats.ability_resource)
		saved_node_data["Unlocked"] = true
		SaveManager.save_equipped_abilities()
	
	ability_level.text = "level %s/%s" % [stored_class_ability_node_stats.current_upgrade_level, stored_class_ability_node_stats.max_upgrade_level]
	
	SaveManager.save_game()

func _on_upgrade_button_button_up() -> void:
	increment_ability_level()
	match stored_class_ability_node_stats.node_type:

		stored_class_ability_node_stats.NODE_TYPE.ABILITY_STAT_BOOST:
			stored_class_ability_node_stats.upgrade_ability_stats()
			
		stored_class_ability_node_stats.NODE_TYPE.CHARACTER_STAT_BOOST:
			stored_class_ability_node_stats.upgrade_character_stats()
			
	deduct_ap()
	
	update_active_ability_description_panel(stored_class_ability_node_stats)

func display_stats_changes(stats_label : RichTextLabel, stat_list : Dictionary, level : int, is_current: bool = true) -> void:
	if is_current:
		stats_label.text = "Current Stats\n"
	else:
		stats_label.text = "Next Stats\n"
	
	for stat in stat_list.keys():
		if not stat_list[stat] is Vector2 and stat_list[stat] != 0.0:
			if stat_list[stat] < 1.0:
				stats_label.text += "+%"+str(int(stat_list[stat] * 100) * level) + " " + stat + "\n"
			elif stat_list[stat] >= 1.0:
				stats_label.text += "+%s %s\n" % [int(stat_list[stat] * level), stat]
			elif stat_list[stat] > -1.0 and stat_list[stat] < 0.0:
					stats_label.text += "+%"+str(int(stat_list[stat] * 100 * level)) + " " + stat + "\n"
			else:
				stats_label.text += "-%s %s\n" % [int(stat_list[stat] * level), stat]

func deduct_ap() -> void:
	PlayerStats.player_stats["Ability Points"] -= stored_class_ability_node_stats.ap_cost
	SignalBus.update_ap_label.emit()
	SaveManager.save_player_stats()

func _on_passive_abilities_button_button_up() -> void:
	warrior_passive_abilities_panel.show()
	warrior_active_abilities_panel.hide()

func _on_active_abilities_button_button_up() -> void:
	#we will update this to consider multiple classes
	warrior_active_abilities_panel.show()
	warrior_passive_abilities_panel.hide()
