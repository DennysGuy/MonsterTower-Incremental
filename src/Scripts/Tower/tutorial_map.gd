class_name TutorialMap extends Map

@onready var guid_log: Label = $GuidLog
var can_enter_tower : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var merchant_enter_notice: Label = $MerchantEnterNotice

@onready var sub_viewport: SubViewport = $CanvasLayer/SubViewportContainer/SubViewport
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var alaisha_notice: Label = $WarmongerSprite/AlaishaNotice

@onready var sword_crafting_station_notice: Label = $SwordCraftingStationNotice
@onready var warmonger_sprite: Sprite2D = $WarmongerSprite

@onready var boat_leave_area: Area2D = $BoatLeaveArea

@onready var fall_through_platform_stone: Sprite2D = $TileMaps/FallThroughPlatformStone
@onready var jump_direction_stone: Sprite2D = $TileMaps/JumpDirectionStone
@onready var ladder_movement_direction_stone: Sprite2D = $TileMaps/LadderMovementDirectionStone

const BOAT_HORN = preload("uid://bt5y3hqi7vb37")
const ENTER_TOWER_FIRST_TIME_SCENE = preload("uid://gjjq2iyol2am")
const TUTORIAL_LICENSE_NOT_ACQUIRED = preload("uid://ctit5lunlhp2n")
const TUTORIAL_INTRO = preload("uid://du1s4dexjtxck")

const MARKET_CANT_ACCESS = preload("uid://cqkfp46tew8pi")
const ALAISHA_CRAFT_FIRST_WEAPON = preload("uid://dgrxildu3n8uw")
const ALAISHA_HEAD_TO_PC = preload("uid://g4l6n3oxv7ee")
const PC_CANT_ACCESS = preload("uid://buwfjrtk8enkl")



var boat_docked : bool = true
var can_enter_market : bool = false

var can_talk_to_alaisha : bool = false
var can_enter_sword_crafting_station : bool = false

var fibre_count : int = 0
var mushie_core_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#hud.animation_player.play("CloseIn")
	SignalBus.spawn_tech_tree.connect(add_tech_tree_to_scene)
	CutsceneManager.go_to_first_floor.connect(go_to_first_floor)
	CutsceneManager.camera_zoomed.connect(zoom_camera)
	CutsceneManager.jump_unlocked.connect(drop_vertical_movement_stones)
	#SignalBus.hide_tech_tree_canvas_layer.connect(hide_tech_tree_canvas_layer)
	GameManager.player_can_move = true
	GameManager.resupply_character= true
	await get_tree().process_frame
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	animation_player.play("Boat_In")
	sfx_player.play_sfx(BOAT_HORN)
	SignalBus.spawn_enemies.emit()
	SignalBus.start_enemy_spawn.emit()
	CutsceneManager.tech_tree_exited_during_tutorial.connect(move_alaisha)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_enter_tower and GameManager.can_open_scene:
		if PlayerStats.facilities_unlocked["Hunter License"] and TechTreeManager.tech_nodes["Attack 1"] > 0:
			Dialogic.start(ENTER_TOWER_FIRST_TIME_SCENE)
		else:
			Dialogic.start(TUTORIAL_LICENSE_NOT_ACQUIRED)
	
	if Input.is_action_just_pressed("interact") and can_enter_market:
		if GameManager.tutorial_can_access_mart:
			spawn_grand_market()
		else:
			Dialogic.start(MARKET_CANT_ACCESS)
	
	if Input.is_action_just_pressed("interact") and can_enter_sword_crafting_station:
		PlayerHudSignalBus.spawn_sword_crafting_station.emit()
	
	if Input.is_action_just_pressed("interact") and can_talk_to_alaisha:
		if GameManager.tutorial_can_access_dojo:
			#this means that we have crafted our sword, and talked to the PC once
			PlayerHudSignalBus.spawn_beginner_tree.emit()
		else:
			#if we can't access the dojo that means we haven't crafted our sword yet or haven't talked to PC
			if GameManager.tutorial_can_access_pc:
				Dialogic.start(ALAISHA_HEAD_TO_PC)
			else:
				Dialogic.start(ALAISHA_CRAFT_FIRST_WEAPON)
	
func _on_tower_entrance_area_body_entered(body: Node2D) -> void:
	if body is Player:
		guid_log.show()
		can_enter_tower = true

func _on_tower_entrance_area_body_exited(body: Node2D) -> void:
	if body is Player:
		guid_log.hide()
		can_enter_tower = false

func spawn_grand_market() -> void:
	CutsceneManager.disable_player_functionality()
	player.velocity = Vector2.ZERO
	PlayerHudSignalBus.spawn_market.emit()

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
		GameManager.in_tech_tree_tutorial = true
		Dialogic.start(TUTORIAL_INTRO)
		await get_tree().process_frame
		boat_leave_area.queue_free()
		
func _on_mobile_shop_area_body_entered(body: Node2D) -> void:
	if body is Player:
		can_enter_market = true
		merchant_enter_notice.show()

func _on_mobile_shop_area_body_exited(body: Node2D) -> void:
	if body is Player:
		can_enter_market = false
		merchant_enter_notice.hide()

func zoom_camera(amount : float) -> void:
	camera.zoom = Vector2(amount,amount)

func _on_sword_crafting_station_body_entered(body: Node2D) -> void:
	if body is Player:
		can_enter_sword_crafting_station = true
		sword_crafting_station_notice.show()
		

func _on_sword_crafting_station_body_exited(body: Node2D) -> void:
	if body is Player:
		can_enter_sword_crafting_station = false
		sword_crafting_station_notice.hide()

func _on_alaisha_area_body_entered(body: Node2D) -> void:
	if body is Player:
		can_talk_to_alaisha = true
		alaisha_notice.show()

func _on_alaisha_area_body_exited(body: Node2D) -> void:
	if body is Player:
		can_talk_to_alaisha = false
		alaisha_notice.hide()

func move_alaisha() -> void:
	warmonger_sprite.global_position = Vector2i(3005,435)


func move_jump_stone() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(jump_direction_stone, "global_position:y", 425,0.5)
	await get_tree().create_timer(0.3).timeout
	SignalBus.shake_camera.emit(1.0)

func move_ladder_movement_stone() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(ladder_movement_direction_stone, "global_position:y", 425,0.5)
	await get_tree().create_timer(0.3).timeout
	SignalBus.shake_camera.emit(1.0)

func move_drop_through_platform_stone() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(fall_through_platform_stone, "global_position:y", 294,0.5)
	await get_tree().create_timer(0.3).timeout
	SignalBus.shake_camera.emit(1.0)

func drop_vertical_movement_stones() -> void:
	move_jump_stone()
	await get_tree().create_timer(0.5).timeout
	move_ladder_movement_stone()
	await get_tree().create_timer(0.5).timeout
	move_drop_through_platform_stone()
