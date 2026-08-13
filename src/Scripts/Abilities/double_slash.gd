class_name DoubleSlash extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enemy : Enemy

var ability : Ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability = PlayerStats.get_equipped_ability("Combat Ability 4")
	animation_player.play("DoubleSlash")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage_enemy() -> void:
	enemy.apply_damage(50,false)
