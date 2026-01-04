class_name PlayerCamera extends Camera2D

@export_category("Follow Character")
@export var player : Player

@export_category("Camera smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8
@export var room_width = 1270
@export var room_height = 720

@export_category("Camera Shake Properties")
@export var random_strength : float = 0.0
@export var shake_fade : float = 0.0

var rng = RandomNumberGenerator.new()
var shake_strength = random_strength
var room_bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(2500, 2500))

var weight : float
var camera_zoom : bool = false
var camera_zoom_out : bool = false
var zoom_variable : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.shake_camera.connect(set_shake_strength)
	shake_strength = 0
	weight = float(11 - smoothing_distance)/100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if player != null:
		var camera_position : Vector2
		
		if smoothing_enabled:
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position
		
		var clamped_position = camera_position.clamp(room_bounds.position, room_bounds.position + room_bounds.size)
		global_position = clamped_position.floor()
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
	

func zoom_camera(focal_length : float, delta):
	zoom.x = lerpf(zoom.x, focal_length, 4.0 * delta)
	zoom.y = lerpf(zoom.y, focal_length, 4.0 * delta)
	
	if abs(zoom.x - focal_length) <= 0.03:
		zoom.x = focal_length
		zoom.y = focal_length


func set_shake_strength(value : float):
	shake_strength = value
	shake_fade = 3

func apply_shake() -> void:
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
