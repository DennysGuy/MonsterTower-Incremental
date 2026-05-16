class_name LaserBall extends EnemyProjectile

const SPEED : int = 250
@onready var timer: Timer = $Timer

var direction : Vector2
var velocity : Vector2 = Vector2()
func _ready() -> void:
	velocity = direction * SPEED
	timer.start()


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	damage_player(area)
