class_name GreySentinelShockWave extends EnemyProjectile


@export var move_speed : float
@export var flip_dir : bool = false
@export var move_dir : int = 1
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.flip_h = flip_dir
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.x += move_speed * move_dir

func _on_timer_timeout() -> void:
	queue_free()

func flip_direction() -> void:
	flip_dir = true
	move_dir = -1


func _on_area_2d_area_entered(area: Area2D) -> void:
	damage_player(area)
