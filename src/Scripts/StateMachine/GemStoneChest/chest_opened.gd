class_name GemStoneChestOpened extends State


func enter() -> void:
	parent.can_hit = false
	parent.enemy_health_bar.hide()
	parent.animation_player.play("Open")

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
		
