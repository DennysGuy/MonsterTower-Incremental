class_name TechNode extends Control

@export var tech_node_stats : TechNodeStats
@export var previous_nodes : Array[TechNode]

@onready var bg: TextureRect = $BG
@onready var icon: TextureRect = $Icon

@onready var tool_tip_marker: Marker2D = $ToolTipMarker

@onready var level_label: RichTextLabel = $LevelLabel

@export var node_type : TechTreeManager.TECH_NODE_TYPE
@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var facilities_notify: Sprite2D = $FacilitiesNotify
@onready var line_position_marker: Marker2D = $LinePositionMarker

var in_range : bool = false
var can_click : bool = false

const NEW_HOVER = preload("uid://dcvxloepmgyvs")
const CLICK_NODE = preload("uid://bawqj0b2h6vsu")
const DENIED = preload("uid://bjj5jqwgvb3ix")



const COMBAT_NODE_BASE = preload("uid://dxd8rdm0eq72d")
const COMBAT_NODE_BASE_DISABLED = preload("uid://dhh0vkjndbkjb")

const COOKING_NODE_BASE = preload("uid://jmpomhw140hm")
const COOKING_NODE_DISABLED = preload("uid://s6ifew86ju74")

const INVENTORY_NODE_BASE = preload("uid://dlhpgti5ut8xv")
const INVENTORY_NODE_DISABLED_BASE = preload("uid://c1v0r087irb3c")

const SMELTING_NODE_BASE = preload("uid://cohaiymavj03p")
const SMELTING_NODE_DISABLED_BASE = preload("uid://jxagu2pjhufe")

const SURVIVAL_NODE_BASE = preload("uid://dkdsi6bo8cq76")
const SURVIVAL_NODE_BASE_DISABLED = preload("uid://cjjng0x22ewx0")

const TRAVERSAL_NODE_BASE = preload("uid://c6g5mvj4a82ai")
const TRAVERSAL_NODE_DISABLED_BASE = preload("uid://bqnpenh5x8ipu")

const HOVER_OVER_NODE = preload("uid://3aj3yvhod6qa")
const NODE_CLICK = preload("uid://cd8y8mjk51lb4")

var node_base_graphic : Texture2D
var node_base_disabled_graphic : Texture2D

var total_bonus : float = 0.0

var stored_node_description_box : NodeDescriptionBox

var current_cost : int = 0
var resource_cost : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match tech_node_stats.stat_relation:
		TechTreeManager.STAT_RELATION.COMBAT:
			node_base_graphic = COMBAT_NODE_BASE
			node_base_disabled_graphic = COMBAT_NODE_BASE_DISABLED
		TechTreeManager.STAT_RELATION.SURVIVAL:
			node_base_graphic = SURVIVAL_NODE_BASE
			node_base_disabled_graphic = SURVIVAL_NODE_BASE_DISABLED
		TechTreeManager.STAT_RELATION.TRAVERSAL:
			node_base_graphic = TRAVERSAL_NODE_BASE
			node_base_disabled_graphic = TRAVERSAL_NODE_DISABLED_BASE
		TechTreeManager.STAT_RELATION.INVENTORY:
			node_base_graphic = INVENTORY_NODE_BASE
			node_base_disabled_graphic = INVENTORY_NODE_DISABLED_BASE
		TechTreeManager.STAT_RELATION.COOKING:
			node_base_graphic = COOKING_NODE_BASE
			node_base_disabled_graphic = COOKING_NODE_DISABLED
		TechTreeManager.STAT_RELATION.CRAFTING:
			node_base_graphic = SMELTING_NODE_BASE
			node_base_disabled_graphic = SMELTING_NODE_DISABLED_BASE
	
	if SaveManager.current_save_game:
		var tech_node_name : String = tech_node_stats.node_name
		var saved_data = SaveManager.current_save_game.tech_nodes.get(tech_node_name)
		tech_node_stats.current_level = saved_data["Level"]
		tech_node_stats.unlocked = saved_data["Unlocked"]
		TechTreeManager.tech_nodes[tech_node_stats.node_name] = saved_data["Level"]
	
	if not TechTreeManager.check_node_prereqs.is_connected(check_prereqs):
		TechTreeManager.check_node_prereqs.connect(check_prereqs)
	
	SignalBus.novelty_invention_sold.connect(check_if_can_purchase)
	TechTreeManager.check_if_can_purchase_node.connect(check_if_can_purchase)
	TechTreeManager.save_node_data.connect(save_node_data)
	set_level_label()
	

	
	if tech_node_stats.get_cost() > 0:
		current_cost = tech_node_stats.get_cost()
	
	if tech_node_stats.unlocked:
		#show()
		if GameManager.license_promotion_time:
			set_graphic_as_disabled()
		else:
			if can_click:
				set_graphic_as_enabled()
			else:
				if tech_node_stats.current_level >= tech_node_stats.max_level:
					set_graphic_as_purchased()
				else:
					set_graphic_as_disabled()

	icon.texture = tech_node_stats.icon

	node_type = tech_node_stats.node_type
	check_if_can_purchase()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_click_area_mouse_entered() -> void:
	in_range = true
	
	create_tool_tip()

func _on_click_area_mouse_exited() -> void:
	in_range = false
	remove_tool_tip()

func save_node_data() -> void:
	if SaveManager.current_save_game:
		var node_save = SaveManager.current_save_game.tech_nodes.get(tech_node_stats.node_name)
		node_save["Level"] = tech_node_stats.current_level
		node_save["Unlocked"] = tech_node_stats.unlocked
		SaveManager.save_game()

func deduct_currency() -> void:
	TechTreeManager.currency -= current_cost
	
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
			set_graphic_as_purchased()
	elif can_purchase():
		can_click = true
		set_graphic_as_enabled()
	else:
		can_click = false
		set_graphic_as_disabled()
	
	set_level_label()
		
func can_purchase() -> bool:
	if tech_node_stats.node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		return TechTreeManager.currency >= tech_node_stats.get_cost() and has_resource_quantity()
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
	show_node()
	#animation_player.play("clicked")

func set_level_label() -> void:
	if tech_node_stats.current_level >= tech_node_stats.max_level:
		level_label.text = "[color=yellow]Max[/color]"
		return
	if can_purchase():
		if if_ap_node():
			level_label.text = "[color=green]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.ap_required]
		else:
			level_label.text = "[color=green]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.max_level]
	else:
		if if_ap_node():
			level_label.text = "[color=gray]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.ap_required]
		else:
			level_label.text = "[color=gray]%s/%s[/color]" % [tech_node_stats.current_level,tech_node_stats.max_level]

func if_ap_node() -> bool:
	return tech_node_stats.ap_required >= 1

func remove_tool_tip() -> void:
	stored_node_description_box.close_out()
	
func create_tool_tip() -> void:
	var tool_tip : NodeDescriptionBox = preload("uid://c5r7c3x1vchu4").instantiate()
	tool_tip.node_title.text = "%s (%s/%s)" % [tech_node_stats.node_name,tech_node_stats.current_level,tech_node_stats.max_level]
	tool_tip.tech_node_stats = tech_node_stats
	
	if node_type == TechTreeManager.TECH_NODE_TYPE.FACILITY:
		tool_tip.current_benefits.text = "Facility"
	elif node_type == TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		tool_tip.current_benefits.text = "Ability"
	else:
		var true_total : float = PlayerStats.player_stats[tech_node_stats.stat_name]
		if tech_node_stats.upgrade_interval > 0 and tech_node_stats.upgrade_interval < 1.0:	
			if tech_node_stats.current_level < tech_node_stats.max_level:
				tool_tip.current_benefits.text = str(int(true_total))+"% -> "+str(int(true_total+tech_node_stats.upgrade_interval*100))+"%"
			else:
				tool_tip.current_benefits.text = "+"+str(int(tech_node_stats.upgrade_interval * tech_node_stats.max_level*100))+"%"
		elif tech_node_stats.upgrade_interval >= 1.0:
			if tech_node_stats.current_level < tech_node_stats.max_level:
				tool_tip.current_benefits.text = "%s -> %s" % [int(true_total), int(true_total+tech_node_stats.upgrade_interval)]
			else:
				tool_tip.current_benefits.text = "+%s" %[int(true_total)]
	
	#if tech_node_stats.current_level >= tech_node_stats.max_level:
		#tool_tip.panel.color = Color(tool_tip.unlocked)
	#else:
		#if can_purchase():
			#tool_tip.panel.color = Color(tool_tip.can_buy)
		#else:
			#tool_tip.panel.color = Color(tool_tip.locked)
	if GameManager.license_promotion_time:
		tool_tip.description.text = "Promote License to Continue."
		tool_tip.show_license_promotion_notice()
	else:
		tool_tip.description.text = tech_node_stats.description
	if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
		if TechTreeManager.currency >=  tech_node_stats.get_cost():
			tool_tip.cost.text = "[color=green]Cost: %s/%s[/color]" % [TechTreeManager.currency, current_cost]
		else:
			tool_tip.cost.text = "Cost: %s/%s" % [TechTreeManager.currency, current_cost]
		
		
		if tech_node_stats.get_cost() <= 0:
			tool_tip.cost.text = ""
			tool_tip.spirol_graphic.hide()
		else:
			tool_tip.spirol_graphic.show()
	else:
		if PlayerStats.player_stats["Ability Points"] >= tech_node_stats.ap_required:
			tool_tip.cost.text = "[color=green]AP %s/%s[/color]" % [PlayerStats.player_stats["Ability Points"],tech_node_stats.ap_required]
		else:
			tool_tip.cost.text = "AP %s/%s" % [PlayerStats.player_stats["Ability Points"],tech_node_stats.ap_required]
		
	tool_tip.position = tool_tip_marker.position
	stored_node_description_box = tool_tip
	add_child(tool_tip)

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

func set_graphic_as_purchased() -> void:
	bg.texture = node_base_graphic
	icon.texture = tech_node_stats.icon
	set_icon_modulation(1.0)
	#We'll probably add some sort of particle emitter here too

func set_graphic_as_enabled() -> void:
	bg.texture = node_base_graphic
	icon.texture = tech_node_stats.icon
	set_icon_modulation(0.75)

func set_graphic_as_disabled() -> void:
	bg.texture = node_base_disabled_graphic
	icon.texture = tech_node_stats.disabled_icon
	set_icon_modulation(0.5)

func _on_mouse_entered() -> void:
	in_range = true
	expand()
	play_sfx(NEW_HOVER)
	create_tool_tip()

func _on_mouse_exited() -> void:
	in_range = false
	button_to_normal()
	remove_tool_tip()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range and !GameManager.license_promotion_time:
		if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
			if can_click and TechTreeManager.currency < tech_node_stats.get_cost() and has_resource_quantity():
				play_sfx(DENIED)
				return
		else:
			if can_click and PlayerStats.player_stats["Ability Points"] < tech_node_stats.ap_required and has_resource_quantity():
				play_sfx(DENIED)
				return
		
		if can_click and mouse_entered and event.is_action_pressed("left_click"):
			play_sfx(CLICK_NODE,3)
			#animation_player.play("clicked")
			tech_node_stats.current_level += 1
			if tech_node_stats.node_name == "Attack 1" and tech_node_stats.current_level == 1:
				Dialogic.start("uid://diefhny8oxyi4")
			
			PlayerStats.upgrade_player_stat(tech_node_stats.stat_name,tech_node_stats.upgrade_interval, node_type)
			if node_type != TechTreeManager.TECH_NODE_TYPE.CLASS_ABILITY:
				deduct_currency()
				current_cost = tech_node_stats.get_cost()
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
			TechTreeManager.increment_upgrade_count()
			TechTreeManager.update_currency_label.emit()
			TechTreeManager.check_for_tech_node_purchases.emit()
			HubManager.check_for_node_purchase.emit()
			TechTreeManager.update_tool_tip_info.emit(0)
		else:
			play_sfx(DENIED)

func show_node() -> void:
	if tech_node_stats.unlocked:
		if !previous_nodes.is_empty():
			for node in previous_nodes:
				draw_node_line(node)

		pop_in()

func draw_node_line(previous_node : TechNode) -> void:
	var line: Line2D = Line2D.new()
	line.z_index = -1
	line.width = 20
	get_parent().add_child(line)
	move_child(line, 0)

	var start_pos := line.to_local(previous_node.line_position_marker.global_position)
	var end_pos := line.to_local(line_position_marker.global_position)

	animate_line(line, start_pos, end_pos)
	await get_tree().create_timer(0.05).timeout
		
func animate_line(line : Line2D, start_pos : Vector2, end_pos : Vector2, duration : float = 0.25) -> void:
	line.points = PackedVector2Array([start_pos, start_pos])
	
	var tween : Tween = create_tween()
	tween.tween_method(
		func(value : Vector2):
			line.points[1]=value,
		start_pos,
		end_pos,
		duration
	)
	
	await tween.finished

func pop_in(duration : float = 0.15) -> void:
	visible = true
	scale = Vector2.ZERO
	play_sfx(NEW_HOVER)
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "modulate:a", 1.0, duration)

	await tween.finished


func expand() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale",Vector2(1.05,1.05),0.1)

func button_to_normal() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale",Vector2(1.0,1.0),0.1)

func set_icon_modulation(value : float) -> void:
	bg.modulate.a = value
	icon.modulate.a = value


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func _on_focus_entered() -> void:
	print("I'm in focus! %s " % tech_node_stats.node_name)


func _on_focus_exited() -> void:
	print("I'm Out of focus")
