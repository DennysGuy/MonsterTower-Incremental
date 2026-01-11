class_name ItemSlot extends TextureRect

@export var item : Item

@export var item_icon: TextureRect
@export var quantity_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_quantity_label(quantity : int) -> void:
	quantity_label.text = str(quantity)
	quantity_label.show()
