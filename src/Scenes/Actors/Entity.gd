class_name Entity extends CharacterBody2D

@export var state_machine : StateMachine
@export var animation_player : AnimationPlayer
@export var health_component : HealthComponent
@export var sprite : Sprite2D

@export_group("Detectors")
@export var hurt_box : HurtBox
@export var hit_box : HitBox

@export_group("States")
@export var hit_state : State
@export var dead_state : State

var damageable : bool = true
var is_dead : bool = false
var prev_dir : int = 1

var health : float

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func apply_damage(incoming_damage : int, is_crit : bool):
	var damage = health_component.apply_damage(incoming_damage, is_crit)
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	if is_crit:
		damage_label.set_crit_bg()
	damage_label.global_position.y = global_position.y-40
	damage_label.global_position.x = global_position.x
	damage_label.label.text = damage
	get_parent().add_child(damage_label)

func send_to_hit_state() -> void:
	if hit_state:
		state_machine.change_state(hit_state)

func kill_me() -> void:
	if dead_state:
		state_machine.change_state(dead_state)

func blink_effect() -> void:
	var invincibility_duration : float = 1.5
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration:
		set_textures_visibility(false)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
		set_textures_visibility(true)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
	
	queue_free()

func set_textures_visibility(value : bool) -> void:
	sprite.visible = value
