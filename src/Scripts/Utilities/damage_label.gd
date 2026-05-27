class_name DamageLabel extends Control

@export var label: Label
@export var texture_rect: TextureRect

const CRIT_DAMAGE_LABEL_BG = preload("uid://dg8xqkw54wldh")
const DAMAGE_LABEL_BG = preload("uid://cyyawskdhc3u5")
const PLAYER_DAMAGE_LABEL_BG = preload("uid://bxpulnd5qma2e")
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Grow")
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween : Tween = get_tree().create_tween()	
	tween.tween_property(self, "modulate:a",0.0,1.5)

func _physics_process(delta: float) -> void:
	position.y -= 0.5

func set_crit_bg() -> void:
	texture_rect.texture = CRIT_DAMAGE_LABEL_BG

func set_player_bg() -> void:
	texture_rect.texture = PLAYER_DAMAGE_LABEL_BG

func _on_timer_timeout() -> void:
	queue_free()
