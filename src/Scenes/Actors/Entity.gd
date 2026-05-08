class_name Entity extends CharacterBody2D

@export var state_machine : StateMachine
@export var animation_player : AnimationPlayer
@export var health_component : HealthComponent
@export var sprite : Sprite2D
@export var blink_timer : Timer
@export var stun_timer : Timer
@export var knock_back_wait_time : float
@export var knock_back_direction : int = 1

@export_group("Detectors")
@export var hurt_box : HurtBox
@export var hit_box : HitBox

@export_group("States")
@export var hit_state : State
@export var dead_state : State
@export var stun_state : State

@export_group("Audio")
@export var sfx_player : SFXPlayer

@export_group("State Checks")
var is_stunned : bool = false
var is_silenced : bool = false

var damageable : bool = true
var is_dead : bool = false

var prev_dir : int = 1

const GENERIC_IMPACT_1 = preload("uid://ffdv7g8jgp4y")
const GENERIC_IMPACT_2 = preload("uid://d1bxfv1bv8md8")
const GENERIC_IMPACT_3 = preload("uid://c3puk7hyuliti")

@onready var impacts : Array[AudioStream] = [GENERIC_IMPACT_1, GENERIC_IMPACT_2, GENERIC_IMPACT_3]

var health : float

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func apply_damage(incoming_damage : int, is_crit : bool, label_position : int = 40):
	if !damageable:
		return
	
	if self is Player:
		damageable = false
	
	play_sfx(impacts.pick_random())
	var damage = health_component.apply_damage(incoming_damage, is_crit)
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	if is_crit:
		damage_label.set_crit_bg()
	damage_label.global_position.y = global_position.y-label_position
	damage_label.global_position.x = global_position.x
	damage_label.label.text = damage
	if self is Enemy:
		self.drop_scene.add_child(damage_label)
	else:
		get_parent().add_child(damage_label)

func enable_hit_box() -> void:

	alter_box_status(hit_box, true, false)

func disable_hit_box() -> void:

	alter_box_status(hit_box, false, true)

func enable_hurt_box() -> void:

	alter_box_status(hurt_box, true, false)

func disable_hurt_box() -> void:
		alter_box_status(hurt_box, false, true)

func disable_box_on_frame(box : Area2D) -> void:
		if !box:
			return
			
		box.monitoring = false
		box.monitorable = false

		var shape2 = box.get_child(0)
		if shape2 is CollisionShape2D:
			shape2.disabled = true

func alter_box_status(box : Area2D, monitor_state : bool, collision_state : bool) -> void:
		if !box:
			return
			
		box.set_deferred("monitoring", monitor_state)
		box.set_deferred("monitorable", monitor_state)

		var shape2 = box.get_child(0)
		if shape2 is CollisionShape2D:
			shape2.set_deferred("disabled", collision_state)

func send_to_hit_state() -> void:
	if is_stunned and stun_state:
		send_to_stun_state()
	elif hit_state:
		state_machine.change_state(hit_state)

func send_to_stun_state() -> void:
	if stun_state:
		state_machine.change_state(stun_state)

func kill_me() -> void:
	if dead_state:
		is_dead = true
		if hit_box:
				disable_hit_box()
		if hurt_box:
				disable_hurt_box()
		state_machine.change_state(dead_state)

func blink_effect() -> void:
	if not is_inside_tree():
		return 
		
	var invincibility_duration : float = 0.5
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration:
		if not is_inside_tree():
			return  # Exit cleanly if removed from tree
			
		set_textures_visibility(false)
		
		# Store the timer and check if we're still valid after await
		var blink_timer = get_tree().create_timer(blink_wait_time)
		await blink_timer.timeout
		
		if not is_inside_tree():
			return
			
		blink_current_time += blink_wait_time
		set_textures_visibility(true)
		
		blink_timer = get_tree().create_timer(blink_wait_time)
		await blink_timer.timeout
		
		if not is_inside_tree():
			return
			
		blink_current_time += blink_wait_time
	
	# Final safety check before setting damageable
	if is_inside_tree():
		queue_free()

func set_textures_visibility(value : bool) -> void:
	sprite.visible = value

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
