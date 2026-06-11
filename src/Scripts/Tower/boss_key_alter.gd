class_name BossKeyAlter extends Node2D

enum KEY_TYPE {DIAMOND, CARD, FINAL}
@export var key_type : KEY_TYPE = KEY_TYPE.DIAMOND
@export var key_marker: Marker2D 
@export var spawn_parent : Map
@onready var notice: Label = $Notice

var can_pick_up_key : bool = false
const TASK_COMPLETED = preload("uid://u4g1ea4v5nkg")

var stored_key : BossDoorKey
var player : Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player and !player.held_key and can_pick_up_key:
		stored_key.enable_can_pick_up()
		stored_key.player = player
		stored_key = null
		spawn_disabled_notice()
		GameManager.can_issue_abilities = false
		GameManager.event_speed_mod = 0.75
		SignalBus.set_combat_ability_icon_disabled.emit()

func spawn_diamond_key() -> void:
	await get_tree().process_frame
	var boss_door_key : BossDoorKey = preload("uid://d1ik00bna4wbf").instantiate()
	boss_door_key.set_as_diamond_key()
	stored_key = boss_door_key
	boss_door_key.global_position = key_marker.global_position
	spawn_parent.add_child(boss_door_key)
	
func spawn_card_key() -> void:
	await get_tree().process_frame
	var boss_door_key : BossDoorKey = preload("uid://d1ik00bna4wbf").instantiate()
	boss_door_key.set_as_card_key()
	stored_key = boss_door_key
	boss_door_key.global_position = key_marker.global_position
	spawn_parent.add_child(boss_door_key)
	add_child(boss_door_key)

func spawn_final_key() -> void:
	await get_tree().process_frame
	var boss_door_key : BossDoorKey = preload("uid://d1ik00bna4wbf").instantiate()
	boss_door_key.set_as_final_key()
	stored_key = boss_door_key
	boss_door_key.global_position = key_marker.global_position
	spawn_parent.add_child(boss_door_key)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		notice.show()
		player = body
		if player.held_key == null:
			notice.text = "Press 'E' to grab!"
		else:
			notice.text = "Max Keys Carried!"


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		notice.hide()
		player = null

func unveil_alter() -> void:
	show()
	can_pick_up_key= true
	await get_tree().create_timer(0.5).timeout
	spawn_key()
	
func spawn_key() -> void:
	match key_type:
		KEY_TYPE.DIAMOND:
			spawn_diamond_key()
		KEY_TYPE.CARD:
			spawn_card_key()
		KEY_TYPE.FINAL:
			spawn_final_key()	

func spawn_disabled_notice() -> void:
	play_sfx(TASK_COMPLETED,0.0)
	var notice : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	notice.set_player_bg()
	notice.label.text = "Combat Abilities Disabled!"
	notice.global_position = player.global_position
	get_parent().add_child(notice)

func play_sfx(sound: AudioStream, volume: float):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
