class_name TechNode extends Node2D

@export var tech_node_stats : TechNodeStats
@onready var icon: Sprite2D = $Icon
@onready var bg: Sprite2D = $BG

@onready var tool_tip_marker: Marker2D = $ToolTipMarker



@onready var level_label: RichTextLabel = $LevelLabel

@export var node_type : TechTreeManager.TECH_NODE_TYPE
@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var facilities_notify: Sprite2D = $FacilitiesNotify

var mouse_entered : bool = false
var can_click : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const NODE_BASE_DISABLED_V_2 = preload("uid://172gew05sy1s")
const NODE_BASE_ENABLED_V_2 = preload("uid://bq14rlsnw3mdh")
const NODE_BASE_UNLOCKED_V_2 = preload("uid://bdbeuw5un1m3o")
const HOVER_OVER_NODE = preload("uid://3aj3yvhod6qa")
const NODE_CLICK = preload("uid://cd8y8mjk51lb4")

const FACILITY_NODE_BASE_DISABLED_V_2 = preload("uid://c8qnk0k4bmquq")
const FACILITY_NODE_BASE_ENABLED_V_2 = preload("uid://k40nmsc0dbc8")
const FACILITY_NODE_UNLOCKED_V_2 = preload("uid://cvqtlryenuafk")

var total_bonus : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SaveManager.current_save_game:
		var tech_node_name : String = tech_node_stats.node_name
		var saved_data = SaveManager.current_save_game.tech_nodes.get(tech_node_name)
		tech_node_stats.current_level = saved_data["Level"]
		tech_node_stats.unlocked = saved_data["Unlocked"]
		TechTreeManager.tech_nodes[tech_node_stats.node_name] = saved_data["Level"]
	
	if not TechTreeManager.check_node_prereqs.is_connected(check_prereqs):
		TechTreeManager.check_node_prereqs.connect(check_prereqs)

	TechTreeManager.check_if_can_purchase_node.connect(check_if_can_purchase)
	TechTreeManager.save_node_data.connect(save_node_data)
	set_level_label()
	if tech_node_stats.unlocked:
		show()
		if can_click:
			match node_type:
				TechTreeManager.TECH_NODE_TYPE.ABILITY:
					bg.texture = NODE_BASE_ENABLED_V_2
				TechTreeManager.TECH_NODE_TYPE.FACILITY:
					bg.texture = FACILITY_NODE_BASE_ENABLED_V_2
				TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
					bg.texture = FACILITY_NODE_BASE_ENABLED_V_2
		else:
			if tech_node_stats.current_level >= tech_node_stats.max_level:
				match node_type:
					TechTreeManager.TECH_NODE_TYPE.ABILITY:
						bg.texture = NODE_BASE_UNLOCKED_V_2
					TechTreeManager.TECH_NODE_TYPE.FACILITY:
						bg.texture = FACILITY_NODE_UNLOCKED_V_2
					TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
						bg.texture = FACILITY_NODE_UNLOCKED_V_2
						
				if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
					facilities_notify.show()
			else:
				match node_type:
					TechTreeManager.TECH_NODE_TYPE.ABILITY:
						bg.texture = NODE_BASE_DISABLED_V_2
					TechTreeManager.TECH_NODE_TYPE.FACILITY:
						bg.texture = FACILITY_NODE_BASE_DISABLED_V_2
					TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
						bg.texture = FACILITY_NODE_BASE_DISABLED_V_2
				facilities_notify.hide()
	else:
		hide()
		
	
	icon.texture = tech_node_stats.icon

	node_type = tech_node_stats.node_type
	check_if_can_purchase()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_click_area_mouse_entered() -> void:
	mouse_entered = true
	sfx_player.play_sfx(HOVER_OVER_NODE)
	create_tool_tip()

func _on_click_area_mouse_exited() -> void:
	mouse_entered = false
	remove_tool_tip()

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		if can_click and TechTreeManager.currency < tech_node_stats.currency_required and has_resource_quantity():
			print("Not enough currency!")
			return
	else:
		if can_click and PlayerStats.player_stats["Ability Points"] < tech_node_stats.ap_required and has_resource_quantity():
			return
	
	if can_click and mouse_entered and event.is_action_pressed("left_click"):
		sfx_player.play_sfx(NODE_CLICK)
		animation_player.play("clicked")
		tech_node_stats.current_level += 1
		
		TechTreeManager.increment_upgrade_count()
		PlayerStats.upgrade_player_stat(tech_node_stats.stat_name,tech_node_stats.upgrade_interval, node_type)
		if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
			deduct_currency()
		else:
			deduct_ap()
			
		deduct_resources()
		
		if tech_node_stats.upgrade_interval > 0:
			total_bonus += tech_node_stats.upgrade_interval
			TechTreeManager.update_tool_tip_info.emit(total_bonus)
			#update label here
		
		#print("this is val of dict node before hand: %s" % [TechTreeManager.tech_nodes[tech_node_stats.node_name]])
		TechTreeManager.tech_nodes[tech_node_stats.node_name] += 1
		QuestManager.check_node_name.emit(tech_node_stats.node_name)
		set_level_label()
		#print("this is val of dict node after: %s" % [TechTreeManager.tech_nodes[tech_node_stats.node_name]] )
		check_if_can_purchase()
		TechTreeManager.check_node_prereqs.emit()
		TechTreeManager.check_if_can_purchase_node.emit()
		
		if node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY and PlayerStats.player_stats["Class"] == "Junior Hunter":
			TechTreeManager.check_if_can_show_class_select_node.emit()
		
		SaveManager.save_tech_tree_data()
		SaveManager.save_player_stats()
		SaveManager.save_inventories()
		save_node_data()
		TechTreeManager.save_node_data.emit()

func save_node_data() -> void:
	if SaveManager.current_save_game:
		var node_save = SaveManager.current_save_game.tech_nodes.get(tech_node_stats.node_name)
		node_save["Level"] = tech_node_stats.current_level
		node_save["Unlocked"] = tech_node_stats.unlocked
		SaveManager.save_game()

func deduct_currency() -> void:
	TechTreeManager.currency -= tech_node_stats.currency_required
	TechTreeManager.update_currency_label.emit()
	
func deduct_ap() -> void:
	PlayerStats.player_stats["Ability Points"] -= tech_node_stats.ap_required
	SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.AP)
	TechTreeManager.update_available_ap_label.emit()
	#update an ap label here

func deduct_resources() -> void:
	InventoryManager.remove_resources_from_inventory(tech_node_stats.materials_required)

func check_if_can_purchase() -> void:
	if tech_node_stats.current_level >= tech_node_stats.max_level:
		can_click = false
		if tech_node_stats.current_level >= tech_node_stats.max_level:
			match node_type:
				TechTreeManager.TECH_NODE_TYPE.ABILITY:
					bg.texture = NODE_BASE_UNLOCKED_V_2
				TechTreeManager.TECH_NODE_TYPE.FACILITY:
					bg.texture = FACILITY_NODE_UNLOCKED_V_2
			facilities_notify.hide()
	elif can_purchase():
		can_click = true
		match node_type:
			TechTreeManager.TECH_NODE_TYPE.ABILITY:
				bg.texture = NODE_BASE_ENABLED_V_2
			TechTreeManager.TECH_NODE_TYPE.FACILITY:
				bg.texture = FACILITY_NODE_BASE_ENABLED_V_2
				
		if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
			facilities_notify.show()
	else:
		can_click = false
		match node_type:
			TechTreeManager.TECH_NODE_TYPE.ABILITY:
				bg.texture = NODE_BASE_DISABLED_V_2
			TechTreeManager.TECH_NODE_TYPE.FACILITY:
				bg.texture = FACILITY_NODE_BASE_DISABLED_V_2
		facilities_notify.hide()
	
	set_level_label()
		
func can_purchase() -> bool:
	if tech_node_stats.node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		return TechTreeManager.currency >= tech_node_stats.currency_required and has_resource_quantity()
	else:
		return PlayerStats.player_stats["Ability Points"] >= tech_node_stats.ap_required and has_resource_quantity()

func check_prereqs() -> void:
	if tech_node_stats.unlocked:
		return

	for req in tech_node_stats.prereqs:
		if not TechTreeManager.check_prereq(req):
			return

	unlock_node()
	save_node_data()

func unlock_node() -> void:
	tech_node_stats.unlocked = true
	check_if_can_purchase()
	show()
	animation_player.play("clicked")

func set_level_label() -> void:
	if tech_node_stats.current_level >= tech_node_stats.max_level:
		level_label.text = "[color=yellow]Max[/color]"
		return
	if can_purchase():
		level_label.text = "[color=green]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.max_level]
	else:
		level_label.text = "[color=gray]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.max_level]

func remove_tool_tip() -> void:
	for tool_tip in get_tree().get_nodes_in_group("ToolTips"):
		tool_tip.remove_tool_tip()

func create_tool_tip() -> void:
	var tool_tip : ToolTip = preload("uid://gqi5stq8kadl").instantiate()
	tool_tip.node_title.text = "%s (%s/%s)" % [tech_node_stats.node_name,tech_node_stats.current_level,tech_node_stats.max_level]
	tool_tip.tech_node_stats = tech_node_stats
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
		tool_tip.current_benefits.text = "Facility"
	elif node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		tool_tip.current_benefits.text = "Ability"
	else:
		if tech_node_stats.upgrade_interval > 0 and tech_node_stats.upgrade_interval < 1.0:	
			if tech_node_stats.current_level < tech_node_stats.max_level:
				tool_tip.current_benefits.text = str(total_bonus*100)+"% -> "+str(total_bonus*100+tech_node_stats.upgrade_interval*100)+"%"
			else:
				tool_tip.current_benefits.text = "+"+str(total_bonus*100)+"%"
		elif tech_node_stats.upgrade_interval >= 1.0:
			if tech_node_stats.current_level < tech_node_stats.max_level:
				tool_tip.current_benefits.text = "%s -> %s" % [int(total_bonus), int(total_bonus+tech_node_stats.upgrade_interval)]
			else:
				tool_tip.current_benefits.text = "+%s" %[int(total_bonus)]
	
	if tech_node_stats.current_level >= tech_node_stats.max_level:
		tool_tip.panel.color = Color(tool_tip.unlocked)
	else:
		if can_purchase():
			tool_tip.panel.color = Color(tool_tip.can_buy)
		else:
			tool_tip.panel.color = Color(tool_tip.locked)
	
	tool_tip.description.text = tech_node_stats.description
	if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		tool_tip.cost.text = "Cost: %s" % [tech_node_stats.currency_required]
	else:
		tool_tip.cost.text = "AP %s" % [tech_node_stats.ap_required]
		
	TechTreeManager.add_tool_tip.emit(tool_tip, is_on_right_half(self))
	
func is_on_right_half(node: Node2D) -> bool:
	var screen_x := node.get_global_transform_with_canvas().origin.x

	var half_x := get_viewport().get_visible_rect().size.x * 0.5

	return screen_x > half_x

func has_resource_quantity() -> bool:
	if tech_node_stats.materials_required.is_empty():
		return true

	for resource in tech_node_stats.materials_required:
		for item in resource.keys():
			match item.item_type:
				item.ITEM_TYPE.CRAFTING:
					if InventoryManager.get_quantity(item, "Crafting Items") < resource[item]:
						return false
				item.ITEM_TYPE.COOKING:
					if InventoryManager.get_quantity(item, "Cooking Items") < resource[item]:
						return false
				item.ITEM_TYPE.ORE:
					if InventoryManager.get_quantity(item, "Ore") < resource[item]:
						return false
				item.ITEM_TYPE.USE:
					if InventoryManager.get_quantity(item, "Use") < resource[item]:
						return false
		
	return true
