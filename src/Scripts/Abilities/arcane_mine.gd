class_name ArcaneMine extends CharacterBody2D

const GRAVITY : float = 1200.0

@export var speed = 300.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var area_2d: Area2D = $Area2D



@export var dir : int = 1
var ability : Ability
var player : Player

func _ready() -> void:
	ability = PlayerStats.get_equipped_ability("Combat Ability 2")
	animation_player.play("Idle")
	timer.wait_time = ability.up_time
	timer.start()
	velocity = Vector2(speed * dir,-100)
	await get_tree().create_timer(0.5).timeout
	area_2d.get_child(0).disabled = false

	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	if area is HurtBox and parent is Enemy:
		animation_player.play("Burst")


func _on_timer_timeout() -> void:
	queue_free()
