class_name ReplenishingAlter extends Node2D

enum TYPE {HP, MP}
@export var type : TYPE = TYPE.HP
@export var full_texture : Texture2D
@export var emptied_texture : Texture2D

@onready var graphic: Sprite2D = $Graphic

const HP_CHALLICE_CONSUME = preload("uid://cv74hhpoa0b3q")
const MP_VIAL_CONSUME = preload("uid://g5kb8aipi1r8")

const REPLENISHING_CHALICE_HP_EMPTY = preload("uid://c7i5u3tjajops")
const REPLENISHING_CHALICE_HP_FULL = preload("uid://cqgo1ndavekv1")

const MP_VIAL_EMPTY = preload("uid://dhah5euxlc36r")
const MP_VIAL_FULL = preload("uid://bj8yk31astdj3")
@onready var notice: Label = $Notice

var player_in_range : bool = false
var depleted : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_textures()
	graphic.texture = full_texture
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and !depleted:
		replenish_resource()
		

func initialize_textures() -> void:
	match type:
		TYPE.HP:
			full_texture = REPLENISHING_CHALICE_HP_FULL
			emptied_texture = REPLENISHING_CHALICE_HP_EMPTY
		TYPE.MP:
			full_texture = MP_VIAL_FULL
			emptied_texture = MP_VIAL_EMPTY
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		if !depleted:
			notice.text = "Press 'E' to Consume"
		else:
			notice.text = "Resources Exhausted."
		notice.show()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()

func replenish_resource() -> void:
	match type:
		TYPE.HP:
			var health_recovery_amount : int = int(PlayerStats.player_stats["HP Recovery"] * PlayerStats.get_total_max_health())
			PlayerStats.recover_hp(health_recovery_amount)
			play_sfx(HP_CHALLICE_CONSUME)
		TYPE.MP:
			var mp_recovery_amount : int = int(PlayerStats.player_stats["MP Recovery"] * PlayerStats.get_total_max_mp())
			PlayerStats.recover_mp(mp_recovery_amount)
			play_sfx(MP_VIAL_CONSUME)
	
	depleted = true
	graphic.texture = emptied_texture
	notice.hide()


func spawn_as_hp_chalice() -> void:
	type = TYPE.HP

func spawn_as_mp_vial() -> void:
	type = TYPE.MP

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
