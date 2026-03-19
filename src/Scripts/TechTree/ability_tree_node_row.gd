class_name AbilityTreeNodeRow extends Panel

@export var class_relation : String
@export var unlock_level : int
@export var is_unlocked : bool = false
@export var is_stat_boost_row : bool = false
@export var max_sigils : int = 0

@onready var focus_marker: Marker2D = $FocusArea

@onready var select_arrows: Control = $SelectArrows

@export var ability_row_lock : AbilityRowLock
@export var arrow_guide : TextureRect
@onready var sigils_left_label: Label = $SigilsLeftLabel

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

func set_as_stat_boost_row() -> void:
	var unlocked_state  = SaveManager.current_save_game.class_ability_rows[class_relation][unlock_level]
	sigils_left_label.text = "Select: %s" % unlocked_state["Sigils Left"]
	
	
func play_lock_break_animation() -> void:
	play_sfx(ABILITY_ROW_UNLOCKED)
	ability_row_lock.animation_player.play("LockBreak")

func load_state() -> void:
	var unlocked_state  = SaveManager.current_save_game.class_ability_rows[class_relation][unlock_level]
	is_unlocked = unlocked_state["Unlocked"]
	if is_stat_boost_row:
		sigils_left_label.show()
		sigils_left_label.text = "Select: %s" % unlocked_state["Sigils Left"]
		#ability_row_lock.hide()

func sigils_remain() -> bool:
	var unlocked_state  = SaveManager.current_save_game.class_ability_rows[class_relation][unlock_level]
	return unlocked_state["Sigils Left"] > 0

func update_sigils_left() -> void:
	if !is_stat_boost_row:
		return
	
	var unlocked_state  = SaveManager.current_save_game.class_ability_rows[class_relation][unlock_level]
	unlocked_state["Sigils Left"] -= 1
	
	sigils_left_label.text = "Select: %s" % unlocked_state["Sigils Left"]

	if unlocked_state["Sigils Left"] <= 0:
		ability_row_lock.set_as_stat_boost_block()
		
	SaveManager.save_game()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
