class_name CircleOfTruth extends Node2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var hit_box: HitBox = $HitBox
var ability : Ability
@onready var attack_timer: Timer = $AttackTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#we will have to get the ability's actual wait time
	timer.start()
	attack_timer.start()
	audio_stream_player.play()
	ability = PlayerStats.get_equipped_ability("Combat Ability 2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()


func _on_attack_timer_timeout() -> void:
	attack_enemies()

func attack_enemies() -> void:
	var enemies = hit_box.get_overlapping_areas()
	for area in enemies:
		if !is_instance_valid(area):
			continue
		
		var parent = area.get_parent() 
		if parent is Enemy:
			parent.apply_slow_and_damage(ability.base_attack,ability.move_speed_modifier,ability.slow_wait_time)
		await get_tree().create_timer(0.1).timeout
