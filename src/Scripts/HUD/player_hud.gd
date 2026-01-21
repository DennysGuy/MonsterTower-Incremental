class_name PlayerHUD extends CanvasLayer

@onready var player_health_bar: TextureProgressBar = $PlayerHUD/PlayerHealthBar
@onready var player_mp_bar: TextureProgressBar = $PlayerHUD/PlayerMPBar
@onready var player_hud: Control = $PlayerHUD
@export var animation_player: AnimationPlayer
@onready var hp_label: Label = $PlayerHUD/HPLabel
@export var map_name_label: Label
@onready var bag_animation_player: AnimationPlayer = $BagAnimationPlayer
var bag_showing : bool = false
var map_name : String = ""

@export var expedition_timer: ExpeditionTimerLocal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_player_health.connect(update_player_health)
	SignalBus.spawn_respawn_box.connect(spawn_respawn_box)
	
	player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	player_health_bar.value = player_health_bar.max_value
	
	player_mp_bar.max_value = PlayerStats.player_stats["Max MP"]
	player_mp_bar.value = player_mp_bar.max_value
	update_player_health(int(PlayerStats.player_stats["Max Health"]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_bag"):
		show_bag()

func update_player_health(value : int) -> void:
	player_health_bar.value = value
	hp_label.text = "%s/%s" % [int(player_health_bar.value), int(player_health_bar.max_value)]

func spawn_respawn_box() -> void:
	var respawn_box : RespawnBox = preload("uid://dv20tfcnkjyux").instantiate()
	player_hud.add_child(respawn_box)

func show_bag() -> void:
	bag_showing = !bag_showing
	if bag_showing:
		bag_animation_player.play("ShowBag")
	else:
		bag_animation_player.play("HideBag")

func start_expedition_timer() -> void:
	expedition_timer.show()
	if !GameManager.expedition_timer_started:
		ExpeditionTimer.start_timer()
