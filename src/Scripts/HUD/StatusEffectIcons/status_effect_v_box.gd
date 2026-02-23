class_name StatusEffectVBox extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_break_status_icon(current_count : int, max_count : int) -> void:
	remove_break_count_icon()
	var break_status_icon : BreakStatusIcon = preload("uid://30gaeu6sni53").instantiate()
	break_status_icon.set_count_label(current_count,max_count)
	add_child(break_status_icon)
	
func remove_break_count_icon() -> void:
	if get_children().is_empty():
		return
	
	for icon in get_children():
		if icon is BreakStatusIcon:
			icon.queue_free()
