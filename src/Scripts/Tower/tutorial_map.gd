class_name TutorialMap extends Map

@onready var guid_log: Label = $GuidLog
var can_enter_tower : bool = false

@onready var sub_viewport: SubViewport = $CanvasLayer/SubViewportContainer/SubViewport
@onready var canvas_layer: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)
	GameManager.player_can_move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_enter_tower and PlayerStats.facilities_unlocked["Hunter License"]:
		go_to_first_floor()


func _on_tower_entrance_area_body_entered(body: Node2D) -> void:
	if body is Player:
		guid_log.show()
		if PlayerStats.facilities_unlocked["Hunter License"]:
			guid_log.text = "Congratulations. You've Completed
	The Tower Boot Camp. You are officially a Starspire Hunter.

	Press 'E' to Enter The First Floor.

	Good Luck!"
		else:
			guid_log.text = "Please acquire your Hunter License from the PC to enter the tower!"
		can_enter_tower = true

func _on_tower_entrance_area_body_exited(body: Node2D) -> void:
	if body is Player:
		guid_log.hide()
		can_enter_tower = false


func go_to_first_floor() -> void:
	InventoryManager.clear_bag()
	hud.animation_player.play("CloseOut")
	GameManager.player_can_move = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://src/Scenes/Tower/TowerFloors/Biome1/Floor1-1.tscn")

func add_tech_tree_to_scene() -> void:
	canvas_layer.show()
	var tech_tree : TechTree = preload("uid://b7n3fwd3y85wp").instantiate()
	sub_viewport.add_child(tech_tree)

func hide_tech_tree_canvas_layer() -> void:
	canvas_layer.hide()
