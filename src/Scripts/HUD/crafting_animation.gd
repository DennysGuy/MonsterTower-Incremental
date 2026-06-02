class_name CraftingAnimation extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword: Sprite2D = $Control/Sword
@onready var player_outfit: Sprite2D = $Control/PlayerOutfit
@onready var notice: Label = $Control/Notice


@onready var player_smithing_animation: Sprite2D = $Control/PlayerSmithingAnimation
const PLAYER_CRAFTING_IDLE = preload("uid://w1vqy8w4jgbs")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notice.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_smithing_sequence() -> void:
	MusicPlayer.pause_music()
	animation_player.play("SwoopIn")
	await get_tree().create_timer(1.0).timeout
	animation_player.play("Smithing")
	await get_tree().create_timer(3.5).timeout
	equip_sword()
	animation_player.play("SwordEquipped")
	await get_tree().create_timer(3.0).timeout
	play_swoop_in()
	animation_player.play("SwoopOut")
	await get_tree().create_timer(0.3).timeout
	MusicPlayer.unpause_music()
	await get_tree().create_timer(0.1).timeout
	queue_free()

func play_equipped_sequence() -> void:
	MusicPlayer.pause_music()
	player_smithing_animation.texture = PLAYER_CRAFTING_IDLE
	play_swoop_in()
	animation_player.play("SwoopIn_2")
	await get_tree().create_timer(1.0).timeout
	equip_sword()
	animation_player.play("SwordEquipped")
	await get_tree().create_timer(3.0).timeout
	play_swoop_in()
	animation_player.play("SwoopOut")
	await get_tree().create_timer(0.3).timeout
	MusicPlayer.unpause_music()
	await get_tree().create_timer(0.1).timeout

	queue_free()

func play_class_upgrade_sequence() -> void:
	set_original_player_outfit()
	play_swoop_in()
	animation_player.play("SwoopIn_2")
	await get_tree().create_timer(1.0).timeout
	play_class_up_fanfare()
	animation_player.play("ClassAdvance")
	await get_tree().create_timer(8.0).timeout
	play_swoop_in()
	animation_player.play("SwoopOut")
	await get_tree().create_timer(2.0).timeout
	queue_free()

func play_success_jingle() -> void:
	var crafting_success_jingle : AudioStream = preload("uid://bb5opdvneo5ro")
	play_sfx(crafting_success_jingle)

func play_crafting_swing_1() -> void:
	var crafting_swing : AudioStream = preload("uid://dioei4jfkjx46")
	play_sfx(crafting_swing)

func play_crafting_swing_2() -> void:
	var crafting_swing : AudioStream = preload("uid://di0c7orsevb1o")
	play_sfx(crafting_swing)

func play_crafting_swing_3() -> void:
	var crafting_swing : AudioStream = preload("uid://dm3c6gpa0w1xb")
	play_sfx(crafting_swing)

func equip_sword() -> void:
	sword.texture = SwordGraphics.get_sword_graphic("Weapon Crafted")

func play_whoosh_out() -> void:
	var whoosh : AudioStream = preload("uid://cvn02i878pp3e")
	play_sfx(whoosh)

func play_class_up_fanfare() -> void:
	var fanfare : AudioStream = preload("uid://cw28u06grrwni")
	play_sfx(fanfare)

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_swoop_in() -> void:
	var swoop_in : AudioStream = preload("uid://dc3va7knibxnb")
	play_sfx(swoop_in)

func set_original_player_outfit() -> void:
	player_outfit.texture = OutfitGraphics.get_outfit_graphic("Idle")

func set_new_player_outfit() -> void:
	SignalBus.update_to_new_class_outfit.emit()
	player_outfit.texture = OutfitGraphics.get_outfit_graphic("Idle")
