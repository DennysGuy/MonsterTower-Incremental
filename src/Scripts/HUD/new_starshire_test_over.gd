class_name NewStarShireOver extends Node

@onready var control: Control = $CanvasLayer/Control
@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport
@onready var canvas_layer: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHudSignalBus.spawn_tower_entrance_map.connect(spawn_tower_entrance_map)
	PlayerHudSignalBus.spawn_market.connect(spawn_grand_market)
	PlayerHudSignalBus.spawn_sword_crafting_station.connect(spawn_sword_crafting_menu)
	PlayerHudSignalBus.spawn_gem_stone_station.connect(spawn_gem_stone_menu)
	PlayerHudSignalBus.spawn_beginner_tree.connect(spawn_beginner_tree)
	PlayerHudSignalBus.spawn_warrior_menu.connect(spawn_warrior_tree)
	PlayerHudSignalBus.spawn_class_selection_menu.connect(spawn_class_selection_menu)
	PlayerHudSignalBus.spawn_tech_tree.connect(spawn_tech_tree)
	PlayerHudSignalBus.spawn_job_board_menu.connect(spawn_job_board_menu)
	SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_tech_tree() -> void:
	canvas_layer.show()
	var tech_tree : TechTree = preload("uid://b7n3fwd3y85wp").instantiate()
	sub_viewport.add_child(tech_tree)

func spawn_tower_entrance_map() -> void:	
	canvas_layer.show()
	var tower_entrance_map : TowerEntranceMap = preload("uid://bgurt44iah13x").instantiate()
	control.add_child(tower_entrance_map)

func hide_tech_tree_canvas_layer() -> void:
	canvas_layer.hide()

func spawn_grand_market() -> void:
	canvas_layer.show()
	var market : GrandMarketMenu = preload("uid://cfuw5h0apwpq").instantiate()
	control.add_child(market)

func spawn_sword_crafting_menu() -> void:
	canvas_layer.show()
	var sword_crafting_station : CraftingStationMenu = preload("uid://cc1xppx3tkq4f").instantiate()
	control.add_child(sword_crafting_station)

func spawn_gem_stone_menu() -> void:
	canvas_layer.show()
	var gem_stone_station : GemStoneStation = preload("uid://v4skqw8t11ip").instantiate()
	control.add_child(gem_stone_station)

func spawn_beginner_tree() -> void:
	canvas_layer.show()
	var beginner_ability_tree : BeginnerTechTree = preload("uid://y6ru08whvroa").instantiate()
	sub_viewport.add_child(beginner_ability_tree)

func spawn_warrior_tree() -> void:
	canvas_layer.show()
	var warrior_tech_tree : NewAbilityUpgradeMenu = preload("uid://d0r1bngbqs2ch").instantiate()
	control.add_child(warrior_tech_tree)

func spawn_class_selection_menu() -> void:
	canvas_layer.show()
	var class_selection_menu : ClassSelectionMenu = preload("uid://b404uvbhnmjxd").instantiate()
	control.add_child(class_selection_menu)

func spawn_job_board_menu() -> void:
	canvas_layer.show()
	var job_board_menu : JobBoardMenu = preload("uid://e5wt3r6lpfow").instantiate()
	control.add_child(job_board_menu)
