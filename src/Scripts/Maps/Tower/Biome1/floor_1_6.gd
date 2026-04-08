class_name Biome1Floor6 extends Map

var in_check_point_area : bool = false
@onready var checkpoint_log: Label = $CheckpointLog
#@onready var checkpoint_campfire: AnimatedSprite2D = $CheckpointCampfire
@onready var door_keys: Node = $DoorKeys

@onready var card_key_lock: CardKeyLock = $CardKeyLock
@onready var final_key_lock: FinalKeyLock = $FinalKeyLock
@onready var diamond_key_lock: DiamondKeyLock = $DiamondKeyLock
@onready var boss_door: BossDoor1 = $BossDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hud.animation_player.play("CloseIn")
	#checkpoint_campfire.play("default")
	
	MusicPlayer.stop_player()
	
	SignalBus.update_player_health.emit(player.health)
	SignalBus.update_player_mp.emit()
	SignalBus.unlock_boss_door.connect(unlock_door)

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
	GameManager.player_can_move = false
	player.send_to_idle_state()
	await get_tree().create_timer(0.5).timeout
	diamond_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	card_key_lock.queue_free()
	await get_tree().create_timer(0.5).timeout
	final_key_lock.queue_free()
	await get_tree().create_timer(2.0).timeout
	boss_door.play_door_open_animation()
	SignalBus.shake_camera.emit(5.0)
	await get_tree().create_timer(3.0).timeout
	SignalBus.issue_big_notification.emit("The Boss Door Has been Unlocked!")
	GameManager.player_can_move = true
	
