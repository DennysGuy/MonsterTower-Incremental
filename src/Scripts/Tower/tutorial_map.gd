class_name TutorialMap extends Map

@onready var guid_log: Label = $GuidLog
var can_enter_tower : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sub_viewport: SubViewport = $CanvasLayer/SubViewportContainer/SubViewport
@onready var canvas_layer: CanvasLayer = $CanvasLayer
const BOAT_HORN = preload("uid://bt5y3hqi7vb37")
const ENTER_TOWER_FIRST_TIME_SCENE = preload("uid://gjjq2iyol2am")
const TUTORIAL_LICENSE_NOT_ACQUIRED = preload("uid://ctit5lunlhp2n")

var boat_docked : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#hud.animation_player.play("CloseIn")
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	CutsceneManager.go_to_first_floor.connect(go_to_first_floor)
	
	#SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)
	GameManager.player_can_move = true
	GameManager.resupply_character= true
	await get_tree().process_frame
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	animation_player.play("Boat_In")
	sfx_player.play_sfx(BOAT_HORN)
	SignalBus.spawn_enemies.emit()
	SignalBus.start_enemy_spawn.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_enter_tower and GameManager.can_open_scene:
		if PlayerStats.facilities_unlocked["Hunter License"]:
			Dialogic.start(ENTER_TOWER_FIRST_TIME_SCENE)
		else:
			Dialogic.start(TUTORIAL_LICENSE_NOT_ACQUIRED)
	

func _on_tower_entrance_area_body_entered(body: Node2D) -> void:
	if body is Player:
		guid_log.show()
		can_enter_tower = true

func _on_tower_entrance_area_body_exited(body: Node2D) -> void:
	if body is Player:
		guid_log.hide()
		can_enter_tower = false


func go_to_first_floor() -> void:
	InventoryManager.clear_bag()
	PlayerHudSignalBus.play_close_out_animation.emit()
	GameManager.player_can_move = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("uid://cd433cwll7hc")

func add_tech_tree_to_scene() -> void:
	GameManager.player_can_move = false
	GameManager.can_open_bag = false
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_tech_tree.emit()


func issue_cross_fade() -> void:
	PlayerHudSignalBus.trigger_cross_fade.emit()
	await get_tree().create_timer(0.5).timeout
	await spawn_player()
	await get_tree().create_timer(0.3).timeout
	PlayerHudSignalBus.update_player_bars.emit()
	camera.player = get_tree().get_first_node_in_group("Player")


func _on_boat_leave_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if boat_docked:
			sfx_player.play_sfx(BOAT_HORN)
			animation_player.play("Boat_Out")
			boat_docked = false
