class_name ItemSlot extends TextureRect

@export var item : Item

enum SLOT_TYPE {BAG, SHOP}
@export var slot_type : SLOT_TYPE = SLOT_TYPE.BAG

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

func set_as_shop_slot() -> void:
	slot_type = SLOT_TYPE.SHOP

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if slot_type == SLOT_TYPE.BAG:
				return
			
			InventoryManager.populate_market_menu.emit(item)
