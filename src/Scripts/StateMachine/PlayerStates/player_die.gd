class_name PlayerDieState extends State

@export var hit : AudioStream
@export var death_fanfare : AudioStream

func enter() -> void:
	if parent.can_spawn_gravestone:
		parent.disable_hurt_box()
		parent.disable_hit_box()
		parent.sfx_player.play_sfx(hit)
		parent.sfx_player.play_sfx(death_fanfare)
		GameManager.expedition_timer_started = false
		parent.damageable = false
		parent.clear_sprites()
		spawn_ghost()
		await get_tree().create_timer(3.0).timeout
		SignalBus.spawn_respawn_box.emit()
		
		parent.can_spawn_gravestone = false
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
		

func spawn_ghost() -> void:
	var tomb_stone : PlayerTombStone = preload("uid://bquglqrgeol06").instantiate()
	tomb_stone.global_position = parent.global_position
	parent.get_parent().add_child(tomb_stone)
