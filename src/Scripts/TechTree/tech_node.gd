class_name TechNode extends Node2D

@export var tech_node_stats : TechNodeStats
@onready var icon: Sprite2D = $Icon

@onready var tool_tip_marker: Marker2D = $ToolTipMarker

@onready var level_label: Label = $LevelLabel

var mouse_entered : bool = false
var can_click : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var total_bonus : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_label()
	if tech_node_stats.unlocked:
		show()
	else:
		hide()
	
	icon.texture = tech_node_stats.icon
	TechTreeManager.check_node_prereqs.connect(check_prereqs)

	check_if_can_purchase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_click_area_mouse_entered() -> void:
	mouse_entered = true
	print("hi")
	create_tool_tip()


func _on_click_area_mouse_exited() -> void:
	mouse_entered = false
	remove_tool_tip()


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if can_click and TechTreeManager.currency < tech_node_stats.currency_required:
		print("Not enough currency!")
		return
	
	if can_click and mouse_entered and event.is_action_pressed("left_click"):
		animation_player.play("clicked")
		tech_node_stats.current_level += 1
		
		TechTreeManager.increment_upgrade_count()
		PlayerStats.upgrade_player_stat(tech_node_stats.stat_name,tech_node_stats.upgrade_interval)
		deduct_currency()
		
		if tech_node_stats.upgrade_interval > 0:
			total_bonus += tech_node_stats.upgrade_interval
			TechTreeManager.update_tool_tip_info.emit(total_bonus)
			#update label here
		
		if tech_node_stats.current_level == tech_node_stats.max_level:
			can_click = false
	
		#print("this is val of dict node before hand: %s" % [TechTreeManager.tech_nodes[tech_node_stats.node_name]])
		TechTreeManager.tech_nodes[tech_node_stats.node_name] += 1
		set_level_label()
		#print("this is val of dict node after: %s" % [TechTreeManager.tech_nodes[tech_node_stats.node_name]] )
		TechTreeManager.check_node_prereqs.emit()

func deduct_currency() -> void:
	TechTreeManager.currency -= tech_node_stats.currency_required
	TechTreeManager.update_currency_label.emit()

func check_if_can_purchase() -> void:
	if tech_node_stats.current_level == tech_node_stats.max_level:
		can_click = false
	elif TechTreeManager.currency >= tech_node_stats.currency_required:
		can_click = true

func check_prereqs() -> void:
	if !tech_node_stats.unlocked:
		if tech_node_stats.prereqs.is_empty():
			unlock_node()
			return
			
		var req_check : bool
		for req in tech_node_stats.prereqs:
			req_check = TechTreeManager.check_prereq(req)
		
		if req_check:
			unlock_node()

func unlock_node() -> void:
	print("WE'VE MET ALL REQUIREMENTS!")
	tech_node_stats.unlocked = true
	check_if_can_purchase()
	show()
	animation_player.play("clicked")

func set_level_label() -> void:
	level_label.text = "%s/%s" % [tech_node_stats.current_level,tech_node_stats.max_level]

func remove_tool_tip() -> void:
	for tool_tip in get_tree().get_nodes_in_group("ToolTips"):
		tool_tip.remove_tool_tip()

func create_tool_tip() -> void:
	var tool_tip : ToolTip = preload("uid://gqi5stq8kadl").instantiate()
	tool_tip.node_title.text = "%s (%s/%s)" % [tech_node_stats.node_name,tech_node_stats.current_level,tech_node_stats.max_level]
	tool_tip.tech_node_stats = tech_node_stats
	
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
	
	tool_tip.description.text = tech_node_stats.description
	tool_tip.cost.text = "Cost: %s" % [tech_node_stats.currency_required]
	tool_tip.position = tool_tip_marker.position
	add_child(tool_tip)
