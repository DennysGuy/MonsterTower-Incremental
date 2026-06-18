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

const DOOR_CHALLENGE_THEME_2 = preload("uid://dlop7xqoavdul")


var keys_delivered : int = 0
@onready var enter_door_notice: Label = $EnterDoorNotice

var in_cutscene : bool = false

const CHALLENGE_COMPLETED_JINGLE = preload("uid://cjtvioifwy20x")

@onready var activation_switch: ChallengeActivationSwitch = $ActivationSwitch
const CRAFTING_NOTIFICATION = preload("uid://wyjbs57smen4")
const DENIED = preload("uid://672acnsycbfo")
const RETRO_MAGIC_11 = preload("uid://cu0pel7wloamp")
const RETRO_SWOOOSH_16 = preload("uid://dtrupd03y6qf7")

var lever_order : Array[String] = ["Yellow", "Green", "Red", "Blue"]
var current_set_order : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#hud.animation_player.play("CloseIn")
	#checkpoint_campfire.play("default")
	tower_entrance_data.activation_switch_unlocked = SaveManager.current_save_game.tower_entrance_data["Floor 1-6"]["Activation Switch Unlocked"]
	MusicPlayer.stop_player()
	ExpeditionTimer.stop_timer()
	PlayerHudSignalBus.update_player_health.emit()
	PlayerHudSignalBus.update_player_mp.emit()
	SignalBus.unlock_boss_door.connect(unlock_door)
	SignalBus.start_boss_door_challenge_scene.connect(start_challenge)
	SignalBus.increment_keys_delivered_tracker.connect(increment_key_tracker)
	SignalBus.send_lever_color_name.connect(populate_current_order_list)
	SignalBus.update_banner_info.emit(tower_entrance_data)
	
	if tower_entrance_data.activation_switch_unlocked:
		SignalBus.set_puzzle_levers_on.emit()
		if !tower_entrance_data.hunt_challenge_completed:
			activation_switch.show()
	
	if tower_entrance_data.hunt_challenge_completed:
		destroy_door_locks()
	
	await get_tree().process_frame
	
	QuestManager.check_map_name.emit(map_name)
	unlock_quests()
	PlayerHudSignalBus.update_map_name_label.emit(map_name)

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
	play_sfx(CHALLENGE_COMPLETED_JINGLE,0.0)
	player.send_to_idle_state()
	GameManager.player_can_move = false
	await get_tree().create_timer(3.0).timeout
	play_sfx(RETRO_SWOOOSH_16,0.0)
	diamond_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	play_sfx(RETRO_SWOOOSH_16,0.0)
	card_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	play_sfx(RETRO_SWOOOSH_16,0.0)
	final_key_lock.queue_free()
	await get_tree().create_timer(2.0).timeout
	QuestManager.check_general_task_for_completion.emit("Unlock Boss Door")
	boss_door.play_door_open_animation()
	SignalBus.shake_camera.emit(5.0)
	await get_tree().create_timer(3.0).timeout
	PlayerHudSignalBus.issue_big_notification.emit("The Boss Door Has been Unlocked!")
	await get_tree().create_timer(3.0).timeout
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
	play_sfx(RETRO_MAGIC_11,0.0)
	diamond_key_alter.unveil_alter()
	await get_tree().create_timer(1.0).timeout
	camera.position = card_key_position.position
	await get_tree().create_timer(1.0).timeout
	play_sfx(RETRO_MAGIC_11,0.0)
	card_key_alter.unveil_alter()
	await get_tree().create_timer(1.0).timeout
	camera.position = top_position.position
	await get_tree().create_timer(1.0).timeout
	
	PlayerHudSignalBus.issue_big_notification.emit("Unlock the Door!")
	SignalBus.spawn_enemies.emit()
	SignalBus.start_enemy_spawn.emit()
	MusicPlayer.play_song(DOOR_CHALLENGE_THEME_2)
	await get_tree().create_timer(2.0).timeout
	camera.player = player
	await get_tree().create_timer(1.0).timeout
	ExpeditionTimer.set_time_for_door_challenge(120)
	PlayerHudSignalBus.show_stop_watch.emit()
	PlayerHudSignalBus.load_timer_label.emit()
	PlayerHudSignalBus.issue_big_notification.emit("Ready?!")
	await get_tree().create_timer(2.0).timeout
	
	PlayerHudSignalBus.issue_big_notification.emit("Go!")
	
	GameManager.player_can_move = true
	ExpeditionTimer.start_hunt_timer()
	await get_tree().create_timer(2.0).timeout
	PlayerHudSignalBus.hide_big_notification.emit()
	

func populate_current_order_list(color_name : String) -> void:
	current_set_order.append(color_name)
	
	if current_set_order.size() == lever_order.size():
		check_current_set_order()


func check_current_set_order() -> void:
	
	await get_tree().create_timer(1.0).timeout
	
	if current_set_order == lever_order:
		play_sfx(CRAFTING_NOTIFICATION,0.0)
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
	play_sfx(RETRO_MAGIC_11,0.0)
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
	play_sfx(RETRO_MAGIC_11,0.0)
	activation_switch.show()
	await get_tree().create_timer(2.0).timeout
	QuestManager.check_general_task_for_completion.emit("Find the Door Switch")
	camera.player = player
	GameManager.player_can_move = true

func destroy_door_locks() -> void:
	diamond_key_lock.queue_free()
	card_key_lock.queue_free()
	final_key_lock.queue_free()
