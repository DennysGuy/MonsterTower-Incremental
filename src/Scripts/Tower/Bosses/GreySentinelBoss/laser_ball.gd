class_name LaserBall extends EnemyProjectile

const SPEED : int = 250
@onready var timer: Timer = $Timer
const LASER_BALL_1 = preload("uid://dyt5a2id58wiv")
const LASER_BALL_2 = preload("uid://dbk04vyjs87mj")
const LASER_BALL_3 = preload("uid://dyxo063dlxo8e")

@onready var sfx : Array[AudioStream] = [LASER_BALL_1,LASER_BALL_2,LASER_BALL_3]

var direction : Vector2
var velocity : Vector2 = Vector2()
func _ready() -> void:
	play_sfx(sfx.pick_random())
	velocity = direction * SPEED
	timer.start()


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	rotation += 0.1

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	damage_player(area)
