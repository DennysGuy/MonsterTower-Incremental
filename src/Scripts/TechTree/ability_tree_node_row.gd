class_name AbilityTreeNodeRow extends Panel

@export var class_relation : String
@export var unlock_level : int
@export var is_unlocked : bool = false

@onready var focus_marker: Marker2D = $FocusArea

@onready var select_arrows: Control = $SelectArrows

@export var ability_row_lock : AbilityRowLock
@export var arrow_guide : TextureRect

var enabled_arrow : Texture2D = preload("uid://cskoljhga6af1")
const ABILITY_ROW_UNLOCKED = preload("uid://joo0a5xuf1pm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_arrows() -> void:
	select_arrows.show()

func hide_arrows() -> void:
	select_arrows.hide()

func enable_guide_arrow() -> void:
	arrow_guide.texture = enabled_arrow

func play_lock_break_animation() -> void:
	play_sfx(ABILITY_ROW_UNLOCKED)
	ability_row_lock.animation_player.play("LockBreak")

func load_state() -> void:
	var unlocked_state : bool = SaveManager.current_save_game.class_ability_rows[class_relation][unlock_level]
	is_unlocked = unlocked_state


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
