class_name PlayerHUD extends CanvasLayer

@onready var player_health_bar: TextureProgressBar = $PlayerHUD/PlayerHealthBar
@onready var player_mp_bar: TextureProgressBar = $PlayerHUD/PlayerMPBar
@onready var player_hud: Control = $PlayerHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_player_health.connect(update_player_health)
	SignalBus.spawn_respawn_box.connect(spawn_respawn_box)
	
	player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	player_health_bar.value = player_health_bar.max_value
	
	player_mp_bar.max_value = PlayerStats.player_stats["Max MP"]
	player_mp_bar.value = player_mp_bar.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_player_health(value : int) -> void:
	player_health_bar.value = value


func spawn_respawn_box() -> void:
	var respawn_box : RespawnBox = preload("uid://dv20tfcnkjyux").instantiate()
	player_hud.add_child(respawn_box)
