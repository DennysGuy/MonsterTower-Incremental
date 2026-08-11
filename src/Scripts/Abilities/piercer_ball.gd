class_name PiercerBall extends EnemyProjectile


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail: CPUParticles2D = $Trail
@onready var ball: Sprite2D = $Ball
@onready var timer: Timer = $Timer
@onready var area_2d: Area2D = $Area2D
@export var stored_ability : Ability
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stored_ability = PlayerStats.get_equipped_ability("Combat Ability 1")
	animation_player.play("Fly")
	ball.flip_h = flip_dir
	trail.gravity.x *= move_dir
	timer.wait_time = stored_ability.up_time
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	


func _physics_process(delta: float) -> void:
	position.x += move_speed * move_dir

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Enemy:
		issue_attack(area_2d)
		animation_player.play("Burst")


func _on_timer_timeout() -> void:
	queue_free()
