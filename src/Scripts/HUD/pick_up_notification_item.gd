class_name PickupNotificationItem extends PanelContainer

@export var icon: TextureRect
@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if is_inside_tree():
		var tree := get_tree()
		if tree:
			var tween : Tween = tree.create_tween()
			await tween.tween_property(self, "modulate:a", 0.0, 1.0).finished
			queue_free()
