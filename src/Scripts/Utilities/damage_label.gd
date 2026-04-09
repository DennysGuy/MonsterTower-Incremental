class_name DamageLabel extends Control

@export var label: Label
@export var texture_rect: TextureRect

const CRIT_DAMAGE_LABEL_BG = preload("uid://dg8xqkw54wldh")
const DAMAGE_LABEL_BG = preload("uid://cyyawskdhc3u5")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= 0.2
	var tween : Tween = get_tree().create_tween()	
	tween.tween_property(self, "modulate:a",0.0,1.0)

func set_crit_bg() -> void:
	texture_rect.texture = CRIT_DAMAGE_LABEL_BG

func _on_timer_timeout() -> void:
	queue_free()
