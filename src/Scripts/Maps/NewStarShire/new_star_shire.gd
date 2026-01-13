class_name NewStarShireMap extends Map

@onready var sub_viewport: SubViewport = $CanvasLayer/Control/SubViewportContainer/SubViewport
@onready var guide_log: Label = $GuideLog
@onready var control: Control = $CanvasLayer/Control
@onready var enter_market_label: Label = $EnterMarketLabel
@onready var access_crafting_station: Label = $AccessCraftingStation

var player_in_tower_range : bool = false
var player_in_market_range : bool = false
var player_in_cooking_range : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	hud.animation_player.play("CloseIn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_tower_range:
		go_to_test_floor()
	
	if Input.is_action_just_pressed("interact") and player_in_market_range:
		spawn_grand_market()
		
	if Input.is_action_just_pressed("interact") and player_in_cooking_range:
		spawn_cooking_menu()

func add_tech_tree_to_scene() -> void:
	var tech_tree : TechTree = preload("uid://cotvjq5dygv7p").instantiate()
	sub_viewport.add_child(tech_tree)

func set_guide_log(show_log : bool) -> void:
	if show_log:
		guide_log.show()
	else:
		guide_log.hide()
	
	if PlayerStats.facilities_unlocked["Tower Pass"]:
		guide_log.text = "Press E to enter the tower!"
	else:
		guide_log.text = "You need a Tower pass before you can Enter..."

func _on_tower_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = true
		set_guide_log(true)

func _on_tower_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_tower_range = false
		set_guide_log(false)

func go_to_test_floor() -> void:
	hud.animation_player.play("CloseOut")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/Tower/TowerFloors/TestFloor/TestFloor.tscn")


func spawn_grand_market() -> void:
	var market : GrandMarketMenu = preload("uid://cfuw5h0apwpq").instantiate()
	control.add_child(market)

func spawn_cooking_menu() -> void:
	var cooking_range : CraftingStation = preload("uid://pk5hdfflc6iy").instantiate()
	control.add_child(cooking_range)

func _on_grand_market_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = true
		enter_market_label.show()


func _on_grand_market_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_market_range = false
		enter_market_label.hide()


func _on_cooking_station_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_cooking_range = true
		access_crafting_station.show()


func _on_cooking_station_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_cooking_range = false
		access_crafting_station.hide()
