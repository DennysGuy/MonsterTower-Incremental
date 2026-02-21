class_name StatusEffectIconBar extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_slow_icon_to_bar() -> void:
	remove_slow_icon_from_bar()
	var status_effect_icon : StatusEffectIcon = preload("uid://23q23kg6cy45").instantiate()
	status_effect_icon.set_as_slow_status()
	add_child(status_effect_icon)

func add_silenced_icon_to_bar() -> void:
	remove_silenced_icon_from_bar()
	var status_effect_icon : StatusEffectIcon = preload("uid://23q23kg6cy45").instantiate()
	status_effect_icon.set_as_silenced_status()
	add_child(status_effect_icon)

func remove_slow_icon_from_bar() -> void:
	if get_children().is_empty():
		return
	
	for icon in get_children():
		if icon.is_slow_status_icon():
			icon.queue_free()

func remove_silenced_icon_from_bar() -> void:
	
	if get_children().is_empty():
		return
	
	for icon in get_children():
		if icon.is_silenced_status_icon():
			icon.queue_free()
