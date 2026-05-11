class_name BuffBar extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHudSignalBus.add_buff_activated_icon.connect(add_buff_icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_buff_icon(timer : Timer, ability : Ability) -> void:
	
	if has_buff(ability):
		return
	
	var buff_icon : BuffActivatedIcon = preload("uid://bxbd2qixwpvxs").instantiate()
	buff_icon.initialize(timer, ability)
	add_child(buff_icon)


func has_buff(ability) -> bool:
	if get_children().is_empty():
		return false
	
	for child in get_children():
		if child.stored_ability == ability:
			return true
	
	return false
