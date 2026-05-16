class_name GreySentinelBoss extends Boss

@onready var timer: Timer = $Timer

var left_hand_laser : HandCanonLaser
var right_hand_laser : HandCanonLaser

@onready var head_position_marker: Marker2D = $BodyParts/Head/HeadPositionMarker

@onready var left_hand: Sprite2D = $BodyParts/LeftHand
@onready var right_hand: Sprite2D = $BodyParts/RightHand

@onready var left_side_shock_wave_area: Marker2D = $LeftSideShockWaveArea
@onready var right_side_shock_wave_area: Marker2D = $RightSideShockWaveArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	PlayerHudSignalBus.update_boss_hp_bar.emit(enemy_stats.max_health, health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot_shock_waves_left() -> void:
	spawn_left_side_shock_waves()
	SignalBus.shake_camera.emit(15)

func shoot_shock_waves_right() -> void:
	spawn_right_side_shock_waves()
	SignalBus.shake_camera.emit(15)

func fire_left_hand_laser() -> void:
	var laser : HandCanonLaser = preload("uid://bdqehuvsrx1sx").instantiate()
	laser.enemy = self
	left_hand_laser = laser
	left_hand.add_child(laser)
	SignalBus.shake_camera.emit(20)
	
func fire_right_hand_laser() -> void:
	var laser : HandCanonLaser = preload("uid://bdqehuvsrx1sx").instantiate()
	laser.enemy = self
	right_hand_laser = laser
	right_hand.add_child(laser)
	SignalBus.shake_camera.emit(20)

func destroy_left_hand_laser() -> void:
	left_hand_laser.queue_free()

func destroy_right_hand_laser() -> void:
	right_hand_laser.queue_free()

func spawn_laser_ball() -> void:
	var spawned_player : Player = get_tree().get_first_node_in_group("Player")
	var laser_ball : LaserBall = preload("uid://dg3xo83trcd2m").instantiate()
	laser_ball.enemy = self
	laser_ball.global_position = head_position_marker.global_position
	laser_ball.direction = head_position_marker.global_position.direction_to(spawned_player.global_position)
	get_parent().add_child(laser_ball)

func spawn_left_side_shock_waves() -> void:
	var shock_wave_1 : GreySentinelShockWave = preload("uid://bp566jgbtua5f").instantiate()
	shock_wave_1.flip_direction()
	shock_wave_1.enemy = self
	var shock_wave_2 : GreySentinelShockWave = preload("uid://bp566jgbtua5f").instantiate()
	shock_wave_2.enemy = self
	shock_wave_1.global_position = left_side_shock_wave_area.global_position
	shock_wave_2.global_position = left_side_shock_wave_area.global_position
	get_parent().add_child(shock_wave_1)
	get_parent().add_child(shock_wave_2)

func spawn_right_side_shock_waves() -> void:
	var shock_wave_1 : GreySentinelShockWave = preload("uid://bp566jgbtua5f").instantiate()
	shock_wave_1.flip_direction()
	shock_wave_1.enemy = self
	var shock_wave_2 : GreySentinelShockWave = preload("uid://bp566jgbtua5f").instantiate()
	shock_wave_2.enemy = self
	shock_wave_1.global_position = right_side_shock_wave_area.global_position
	shock_wave_2.global_position = right_side_shock_wave_area.global_position
	get_parent().add_child(shock_wave_1)
	get_parent().add_child(shock_wave_2)
