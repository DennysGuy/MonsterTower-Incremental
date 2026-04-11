class_name ReplenishAlterPositionMarker extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_hp_chalice() -> void:
	var chalice : ReplenishingAlter = preload("uid://ge3kakv58e1b").instantiate()
	chalice.spawn_as_hp_chalice()
	add_child(chalice)

func spawn_mp_vial() -> void:
	var chalice : ReplenishingAlter = preload("uid://ge3kakv58e1b").instantiate()
	chalice.spawn_as_mp_vial()
	add_child(chalice)
