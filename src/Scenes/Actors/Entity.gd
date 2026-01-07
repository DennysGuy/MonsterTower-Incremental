class_name Entity extends CharacterBody2D

@export var state_machine : StateMachine
@export var animation_player : AnimationPlayer
@export var health_component : HealthComponent

@export_group("Detectors")
@export var hurt_box : HurtBox
@export var hit_box : HitBox

@export_group("States")
@export var hit_state : State
@export var dead_state : State

var damageable : bool = true

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
