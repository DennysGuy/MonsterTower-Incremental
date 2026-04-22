class_name Biome1Floor6 extends Map

var in_check_point_area : bool = false
@onready var checkpoint_log: Label = $CheckpointLog
#@onready var checkpoint_campfire: AnimatedSprite2D = $CheckpointCampfire
@onready var door_keys: Node = $DoorKeys

@onready var card_key_lock: CardKeyLock = $CardKeyLock
@onready var final_key_lock: FinalKeyLock = $FinalKeyLock
@onready var diamond_key_lock: DiamondKeyLock = $DiamondKeyLock
@onready var boss_door: BossDoor1 = $BossDoor

@onready var diamond_key_position: Marker2D = $DiamondKeyPosition
@onready var card_key_position: Marker2D = $CardKeyPosition
@onready var final_key_position: Marker2D = $FinalKeyPosition
@onready var activation_switch_position: Marker2D = $ActivationSwitchPosition

@onready var card_key_alter: BossKeyAlter = $CardKeyAlter
@onready var diamond_key_alter: BossKeyAlter = $DiamondKeyAlter
@onready var final_key_alter: BossKeyAlter = $BossKeyAlter

@onready var top_position: Marker2D = $TopPosition
const TEST_DUNGEON_CHALLENGE_THEME = preload("uid://bmdcmdm835j2s")

var keys_delivered : int = 0
@onready var enter_door_notice: Label = $EnterDoorNotice


@onready var activation_switch: ChallengeActivationSwitch = $ActivationSwitch
const CRAFTING_NOTIFICATION = preload("uid://wyjbs57smen4")
const DENIED = preload("uid://672acnsycbfo")
const RETRO_MAGIC_11 = preload("uid://cu0pel7wloamp")
const RETRO_SWOOOSH_16 = preload("uid://dtrupd03y6qf7")
const TEMP_VICTORY_THEME_1 = preload("uid://n4ky26neitxn")
var lever_order : Array[String] = ["Yellow", "Green", "Red", "Blue"]
var current_set_order : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	#checkpoint_campfire.play("default")
	tower_entrance_data.activation_switch_unlocked = SaveManager.current_save_game.tower_entrance_data["Floor 1-6"]["Activation Switch Unlocked"]
	MusicPlayer.stop_player()
	PlayerHudSignalBus.update_player_health.emit()
	PlayerHudSignalBus.update_player_mp.emit()
	SignalBus.unlock_boss_door.connect(unlock_door)
	SignalBus.start_boss_door_challenge_scene.connect(start_challenge)
	SignalBus.increment_keys_delivered_tracker.connect(increment_key_tracker)
	SignalBus.send_lever_color_name.connect(populate_current_order_list)
	
	if tower_entrance_data.activation_switch_unlocked:
		SignalBus.set_puzzle_levers_on.emit()
		if !tower_entrance_data.hunt_challenge_completed:
			activation_switch.show()
	
	if tower_entrance_data.hunt_challenge_completed:
		destroy_door_locks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("interact") and in_check_point_area:
		go_to_starshire()

func _on_checkpoint_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = true
		checkpoint_log.show()

func _on_checkpoint_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_check_point_area = false
		checkpoint_log.hide()


func unlock_door() -> void:
	play_sfx(TEMP_VICTORY_THEME_1)
	player.send_to_idle_state()
	GameManager.player_can_move = false
	await get_tree().create_timer(3.0).timeout
	play_sfx(RETRO_SWOOOSH_16)
	diamond_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	play_sfx(RETRO_SWOOOSH_16)
	card_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	play_sfx(RETRO_SWOOOSH_16)
	final_key_lock.queue_free()
	await get_tree().create_timer(2.0).timeout
	boss_door.play_door_open_animation()
	SignalBus.shake_camera.emit(5.0)
	await get_tree().create_timer(3.0).timeout
	SignalBus.issue_big_notification.emit("The Boss Door Has been Unlocked!")
	GameManager.player_can_move = true

func start_challenge() -> void:
	SignalBus.shake_camera.emit(15.0)
	player.send_to_idle_state()
	GameManager.player_can_move = false
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(3.0).timeout
	camera.player = null
	camera.position = diamond_key_position.position
	await get_tree().create_timer(1.0).timeout
	play_sfx(RETRO_MAGIC_11)
	diamond_key_alter.unveil_alter()
	await get_tree().create_timer(1.0).timeout
	camera.position = card_key_position.position
	await get_tree().create_timer(1.0).timeout
	play_sfx(RETRO_MAGIC_11)
	card_key_alter.unveil_alter()
	await get_tree().create_timer(1.0).timeout
	camera.position = top_position.position
	await get_tree().create_timer(1.0).timeout
	MusicPlayer.play_song(TEST_DUNGEON_CHALLENGE_THEME)
	SignalBus.issue_big_notification.emit("Unlock the Door!")
	SignalBus.spawn_enemies.emit()
	SignalBus.start_enemy_spawn.emit()
	await get_tree().create_timer(2.0).timeout
	camera.player = player
	await get_tree().create_timer(1.0).timeout
	ExpeditionTimer.set_time_for_door_challenge(120)
	hud.expedition_timer.load_timer_label()
	SignalBus.issue_big_notification.emit("Ready?!")
	await get_tree().create_timer(2.0).timeout
	SignalBus.issue_big_notification.emit("Go!")
	
	GameManager.player_can_move = true
	ExpeditionTimer.start_hunt_timer()
	await get_tree().create_timer(2.0).timeout
	SignalBus.hide_big_notification.emit()

func populate_current_order_list(color_name : String) -> void:
	current_set_order.append(color_name)
	
	if current_set_order.size() == lever_order.size():
		check_current_set_order()


func check_current_set_order() -> void:
	
	await get_tree().create_timer(1.0).timeout
	
	if current_set_order == lever_order:
		play_sfx(CRAFTING_NOTIFICATION)
		show_activation_lever()
	else:
		current_set_order.clear()
		sfx_player.play_sfx(DENIED)
		SignalBus.reset_levers.emit()

func increment_key_tracker() -> void:
	keys_delivered += 1
	
	if keys_delivered == 2:
		show_final_key_location()

func show_final_key_location() -> void:
	player.send_to_idle_state()
	GameManager.player_can_move = false
	player.velocity = Vector2.ZERO
	camera.player = null
	await get_tree().create_timer(2.0).timeout
	camera.position = final_key_position.position
	await get_tree().create_timer(2.0).timeout
	play_sfx(RETRO_MAGIC_11)
	final_key_alter.unveil_alter()
	await get_tree().create_timer(1.0).timeout
	camera.player = player
	GameManager.player_can_move = true

func show_activation_lever() -> void:
	
	SaveManager.current_save_game.tower_entrance_data["Floor 1-6"]["Activation Switch Unlocked"] = true
	SaveManager.save_game()
	
	GameManager.player_can_move = false
	player.send_to_idle_state()
	player.velocity = Vector2.ZERO
	camera.player = null
	camera.position = activation_switch_position.position
	await get_tree().create_timer(2.0).timeout
	play_sfx(RETRO_MAGIC_11)
	activation_switch.show()
	await get_tree().create_timer(2.0).timeout
	camera.player = player
	GameManager.player_can_move = true

func destroy_door_locks() -> void:
	diamond_key_lock.queue_free()
	card_key_lock.queue_free()
	final_key_lock.queue_free()
